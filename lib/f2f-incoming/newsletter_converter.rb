require "octokit"
require "thread"
require "tmpdir"

require_relative "command"

module F2fIncoming
  class NewsletterConverter
    include Command

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
          branch = "otto-#{SecureRandom.hexdigest(10)}"
          convert_newsletter mail
          commit mail.subject
          push branch
          open_pr branch, mail.subject
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
      load File.join(site, "_script/convert-newsletters.rb")
      Converter.new.convert(mail)
    end

    def commit(message)
      run! "git", "commit", "-m", message
    end

    def push(branch)
      run! "git", "push", "https://xx:#{ENV["GITHUB_TOKEN"]}@github.com/f", "HEAD:refs/heads/#{branch}"
    end

    def open_pr(branch, title)
      client = Octokit::Client.new access_token: github_token
      client.create_pull_request repo_name, "gh-pages", branch, title
    end

    def run!(*command)
      unless system(*command)
        raise "#{command.join(" ")} failed!"
      end
    end

    # "owner/name"
    def repo_name
      ENV["GITHUB_REPO_NAME"]
    end

    # 40-char token.
    def github_token
      ENV["GITHUB_TOKEN"]
    end

    # A URL we can clone from and push to.
    def repo_url
      "https://xx:#{github_token}@github.com/#{repo_name}.git"
    end
  end
end
