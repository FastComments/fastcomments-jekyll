require "spec_helper"

RSpec.describe FastComments::Jekyll::KeyMapper do
  describe ".to_camel" do
    {
      "tenant_id" => "tenantId",
      "url_id" => "urlId",
      "page_title" => "pageTitle",
      "has_dark_background" => "hasDarkBackground",
      "allow_anon" => "allowAnon",
      "user_id" => "userId",
      "api_host" => "apiHost"
    }.each do |snake, camel|
      it "maps #{snake} -> #{camel}" do
        expect(described_class.to_camel(snake)).to eq(camel)
      end
    end

    it "leaves single-word keys unchanged" do
      %w[region target count url translations readonly].each do |k|
        expect(described_class.to_camel(k)).to eq(k)
      end
    end

    it "accepts symbols" do
      expect(described_class.to_camel(:tenant_id)).to eq("tenantId")
    end
  end

  describe ".map_keys" do
    it "camelizes top-level keys only and does not recurse" do
      input = { "tenant_id" => "demo", "translations" => { "some_key" => "v" } }
      expect(described_class.map_keys(input)).to eq(
        "tenantId" => "demo",
        "translations" => { "some_key" => "v" }
      )
    end
  end
end
