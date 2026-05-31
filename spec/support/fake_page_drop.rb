require "liquid"

# Mimics how real Jekyll exposes `page`: a Liquid::Drop (Jekyll::Drops::DocumentDrop),
# NOT a Hash. It answers page["url"] and dotted Liquid access (page.url), but
# is_a?(Hash) is false — which is exactly the production type our code must handle.
class FakePageDrop < Liquid::Drop
  def initialize(data)
    @data = data
  end

  def liquid_method_missing(key)
    @data[key.to_s]
  end
end
