require "spec_helper"

RSpec.describe FastComments::Jekyll::AttributeParser do
  let(:context) { build_context(page: { "slug" => "my-post", "url" => "/posts/my-post/" }) }

  def parse(markup)
    described_class.parse(markup, context)
  end

  it "returns an empty hash for empty markup" do
    expect(parse("")).to eq({})
    expect(parse("   ")).to eq({})
  end

  it "parses double-quoted strings" do
    expect(parse('tenant_id="demo"')).to eq("tenant_id" => "demo")
  end

  it "parses single-quoted strings and preserves spaces" do
    expect(parse("page_title='Hello World'")).to eq("page_title" => "Hello World")
  end

  it "coerces unquoted integers and floats" do
    expect(parse("count=5")).to eq("count" => 5)
    expect(parse("ratio=1.5")).to eq("ratio" => 1.5)
  end

  it "coerces unquoted booleans" do
    expect(parse("readonly=true allow_anon=false")).to eq("readonly" => true, "allow_anon" => false)
  end

  it "resolves unquoted tokens as Liquid context variables" do
    expect(parse("url_id=page.slug")).to eq("url_id" => "my-post")
  end

  it "drops unresolved variables (nil)" do
    expect(parse("url_id=page.does_not_exist")).to eq({})
  end

  it "parses multiple attributes together" do
    expect(parse('tenant_id="demo" count=3 url_id=page.slug readonly=true')).to eq(
      "tenant_id" => "demo",
      "count" => 3,
      "url_id" => "my-post",
      "readonly" => true
    )
  end

  it "keeps quoted values literal even when they look like variables" do
    expect(parse('url_id="page.slug"')).to eq("url_id" => "page.slug")
  end

  it "resolves dotted variables when page is a Liquid::Drop (real Jekyll)" do
    drop = FakePageDrop.new("url" => "/posts/hello/")
    ctx = build_context(page: drop)
    expect(described_class.parse("url_id=page.url", ctx)).to eq("url_id" => "/posts/hello/")
  end
end
