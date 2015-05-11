require "spec_helper"
require "f2f-incoming/command"

describe F2fIncoming::Command do
  class ExampleCommand
    include F2fIncoming::Command

    def example(a, b)
      a + b
    end
  end

  it { expect(ExampleCommand.example(1, 2)).to eq(3) }
end
