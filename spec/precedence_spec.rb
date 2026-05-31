require "spec_helper"

RSpec.describe "config precedence (global < page-derived < attributes)" do
  let(:resolver) { FastComments::Jekyll::ConfigResolver }

  it "lets explicit attributes beat the page-derived value" do
    ctx = build_context(
      site_config: { "fastcomments" => { "tenant_id" => "demo" } },
      page: { "url" => "/posts/hello/" }
    )
    result = resolver.resolve(ctx, { "url_id" => "explicit" }, derive_page_context: true)
    expect(result["urlId"]).to eq("explicit")
  end

  it "lets the page-derived value beat the global default" do
    ctx = build_context(
      site_config: { "fastcomments" => { "tenant_id" => "demo", "url_id" => "global-id" } },
      page: { "url" => "/posts/hello/" }
    )
    result = resolver.resolve(ctx, {}, derive_page_context: true)
    expect(result["urlId"]).to eq("/posts/hello/")
  end

  it "uses the global default when neither attribute nor derivation applies" do
    ctx = build_context(
      site_config: { "fastcomments" => { "tenant_id" => "demo", "url_id" => "global-id" } },
      page: { "url" => "/posts/hello/" }
    )
    result = resolver.resolve(ctx, {}, derive_page_context: false)
    expect(result["urlId"]).to eq("global-id")
  end

  it "applies snake->camel mapping across all sources" do
    ctx = build_context(
      site_config: { "fastcomments" => { "tenant_id" => "demo" } },
      page: { "url" => "/p/", "title" => "T" }
    )
    result = resolver.resolve(ctx, { "has_dark_background" => true }, derive_page_context: true)
    expect(result).to include("tenantId" => "demo", "pageTitle" => "T", "hasDarkBackground" => true)
  end
end
