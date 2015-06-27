require "octokit"
require "posix/spawn"
require "thread"
require "tmpdir"

require_relative "command"
require_relative "url_generator"

module F2fIncoming
  class NewsletterConverter
    include Command

    def initialize(options = {})
      # "owner/name"
      @repo_name = options.fetch(:repo_name) { ENV["GITHUB_REPO_NAME"] }
      # 40-char token.
      @github_token = options.fetch(:github_token) { ENV["GITHUB_TOKEN"] }
      # A URL we can clone from and push to.
      @repo_url = options.fetch(:repo_url) { ENV["REPO_PUSH_URL"] || "https://xx:#{github_token}@github.com/#{repo_name}.git" }
    end

    def process_async(mail)
      # Fork, because we load code into this process, and don't want to pollute the web process.
      fork do
        begin
          process(mail)
          exit! 0
        rescue => e
          puts e
          exit! 1
        end
      end
    end

    def process(mail)
      Dir.mktmpdir do |tmpdir|
        Dir.chdir clone_f2f_repo(tmpdir) do
          branch = "otto-#{SecureRandom.hex(10)}"
          convert_newsletter mail
          commit mail.subject
          push branch
          open_pr branch, mail.subject, build_pr_body
        end
      end
    end

    private

    # Returns the path of the cloned repo, or raises an error.
    def clone_f2f_repo(tmpdir)
      repo_dir = File.join(tmpdir, "f2f")
      run! "git", "clone", repo_url, repo_dir
      repo_dir
    end

    # Make it a newsletter. `git add`s what it made.
    def convert_newsletter(mail)
      load File.expand_path("_script/convert-newsletters.rb")
      converter = F2fConverter.new
      converter.convert_to_post(mail)
      converter.git_add
    end

    def commit(message)
      run! "git", "commit", "--allow-empty", "-m", message
    end

    def push(branch)
      run! "git", "push", "origin", "HEAD:refs/heads/#{branch}"
    end

    def build_pr_body
      # git status --porcelain looks like this:
      #
      # M  Gemfile
      #  M lib/f2f-incoming/newsletter_converter.rb
      # ?? 2015-05-14-payload.json
      #
      # We want just the filenames, so cut -c4- skips the first three chars of each line.
      child = run! "git status --porcelain _posts | cut -c4-"

      urls = UrlGenerator.new
      child.out.lines.map do |line|
        urls.generate(line)
      end.compact.join("\n")

    rescue => e
      puts e
      nil
    end

    def open_pr(branch, title, body = nil)
      if github_token
        client = Octokit::Client.new access_token: github_token
        pr = client.create_pull_request repo_name, "gh-pages", branch, title, body
        Scrolls.log :at => "create_pull_request", :pr => pr.rels[:html].href
      end
    end

    def run!(*command)
      child = POSIX::Spawn::Child.new(*command)
      unless child.success?
        raise "#{command.join(" ")} failed!\n#{child.out}\n#{child.err}"
      end
      child
    end

    attr_reader :repo_name, :github_token, :repo_url
  end
end
