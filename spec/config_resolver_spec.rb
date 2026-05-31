require "spec_helper"

RSpec.describe FastComments::Jekyll::ConfigResolver do
  it "reads global defaults from site config and camelizes them" do
    ctx = build_context(site_config: { "fastcomments" => { "tenant_id" => "demo" } })
    expect(described_class.resolve(ctx, {})).to eq("tenantId" => "demo")
  end

  it "tolerates a missing fastcomments config block" do
    ctx = build_context
    expect(described_class.resolve(ctx, {})).to eq({})
  end

  context "with page-context derivation enabled" do
    it "derives urlId, url (when site.url present), and pageTitle" do
      ctx = build_context(
        site_config: { "url" => "https://example.com", "fastcomments" => { "tenant_id" => "demo" } },
        page: { "url" => "/posts/hello/", "title" => "Hello" }
      )
      result = described_class.resolve(ctx, {}, derive_page_context: true)
      expect(result).to eq(
        "tenantId" => "demo",
        "urlId" => "/posts/hello/",
        "url" => "https://example.com/posts/hello/",
        "pageTitle" => "Hello"
      )
    end

    it "omits url when site.url is not set" do
      ctx = build_context(
        site_config: { "fastcomments" => { "tenant_id" => "demo" } },
        page: { "url" => "/posts/hello/", "title" => "Hello" }
      )
      result = described_class.resolve(ctx, {}, derive_page_context: true)
      expect(result).not_to have_key("url")
      expect(result["urlId"]).to eq("/posts/hello/")
    end
  end

  context "when page is a Liquid::Drop (real Jekyll, not a Hash)" do
    it "still derives urlId, url, and pageTitle from the drop" do
      drop = FakePageDrop.new("url" => "/posts/hello/", "title" => "Hello")
      ctx = build_context(
        site_config: { "url" => "https://example.com", "fastcomments" => { "tenant_id" => "demo" } },
        page: drop
      )
      result = described_class.resolve(ctx, {}, derive_page_context: true)
      expect(result).to include(
        "tenantId" => "demo",
        "urlId" => "/posts/hello/",
        "url" => "https://example.com/posts/hello/",
        "pageTitle" => "Hello"
      )
    end
  end

  context "with page-context derivation disabled" do
    it "does not derive page values" do
      ctx = build_context(
        site_config: { "url" => "https://example.com", "fastcomments" => { "tenant_id" => "demo" } },
        page: { "url" => "/posts/hello/", "title" => "Hello" }
      )
      result = described_class.resolve(ctx, {}, derive_page_context: false)
      expect(result).to eq("tenantId" => "demo")
    end
  end
end
