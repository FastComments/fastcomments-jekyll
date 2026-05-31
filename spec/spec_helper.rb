require "liquid"
require "fastcomments-jekyll"

Dir[File.join(__dir__, "support", "**", "*.rb")].sort.each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Deterministic container ids so we can assert on exact output.
  config.before(:each) do
    allow(FastComments::Jekyll::Util).to receive(:make_container_id) do |prefix|
      "#{prefix}-testid0"
    end
  end
end
