module RenderHelpers
  FakeSite = Struct.new(:config)

  def deep_stringify(obj)
    case obj
    when Hash
      obj.each_with_object({}) { |(k, v), h| h[k.to_s] = deep_stringify(v) }
    when Array
      obj.map { |v| deep_stringify(v) }
    else
      obj
    end
  end

  def build_site(config = {})
    FakeSite.new(deep_stringify(config))
  end

  # Build a Liquid::Context the way Jekyll does: page variable in scope, site in registers.
  def build_context(page: {}, site_config: {})
    site = build_site(site_config)
    Liquid::Context.new({ "page" => deep_stringify(page) }, {}, { site: site })
  end

  # Parse and render a tag string end-to-end through the real registered tags.
  def render_tag(source, site_config: {}, page: {})
    site = build_site(site_config)
    Liquid::Template.parse(source).render!({ "page" => deep_stringify(page) }, registers: { site: site })
  end
end

RSpec.configure do |config|
  config.include RenderHelpers
end
