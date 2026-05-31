require_relative "lib/fastcomments/version"

Gem::Specification.new do |spec|
  spec.name        = "fastcomments-jekyll"
  spec.version     = FastComments::Jekyll::VERSION
  spec.authors     = ["FastComments"]
  spec.email       = ["support@fastcomments.com"]

  spec.summary     = "Jekyll plugin for FastComments, a live commenting system."
  spec.description = "Liquid tags for embedding FastComments widgets (comments, live chat, " \
                     "collab/image chat, reviews summary, recent comments/discussions, top pages, " \
                     "and user activity feed) into Jekyll sites."
  spec.homepage    = "https://docs.fastcomments.com/guide-lib-jekyll.html"
  spec.license     = "MIT"

  spec.required_ruby_version = ">= 3.0"

  spec.metadata = {
    "source_code_uri" => "https://github.com/FastComments/fastcomments-jekyll",
    "homepage_uri"    => spec.homepage,
    "changelog_uri"   => "https://github.com/FastComments/fastcomments-jekyll/blob/main/CHANGELOG.md"
  }

  spec.files         = Dir["lib/**/*.rb", "README.md", "LICENSE", "CHANGELOG.md"]
  spec.require_paths = ["lib"]

  # The tags use only Liquid APIs (Liquid::Tag, Liquid::Template.register_tag),
  # which Jekyll bundles, but a "-jekyll" plugin conventionally depends on Jekyll.
  # Compatible with Jekyll 3.7+ and 4.x.
  spec.add_runtime_dependency "jekyll", ">= 3.7", "< 5.0"

  spec.add_development_dependency "rspec", "~> 3.0"
end
