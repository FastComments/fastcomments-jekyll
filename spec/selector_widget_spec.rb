require "spec_helper"

RSpec.describe FastComments::Jekyll::SelectorWidget do
  let(:collab_spec) do
    {
      script_path: "/js/embed-collab-chat.min.js",
      script_marker_attr: "data-fc-collab-chat",
      global_name: "FastCommentsCollabChat",
      shortcode_name: "fastcomments_collab_chat"
    }
  end

  it "targets the element by CSS selector and omits a container element" do
    out = described_class.render(collab_spec, { "tenantId" => "demo", "target" => "#post-body" })
    expect(out).not_to include("<div")
    expect(out).not_to include("getElementById")
    expect(out).to include('var target="#post-body";')
    expect(out).to include("document.querySelector(target)")
    expect(out).to include("https://cdn.fastcomments.com/js/embed-collab-chat.min.js")
    expect(out).to include('var marker="data-fc-collab-chat";')
  end

  it "does not include target inside the widget config" do
    out = described_class.render(collab_spec, { "tenantId" => "demo", "target" => "#post-body" })
    expect(out).to include('var config={"tenantId":"demo"};')
  end

  it "honors the EU region" do
    out = described_class.render(collab_spec, { "tenantId" => "demo", "target" => "#x", "region" => "eu" })
    expect(out).to include("https://cdn-eu.fastcomments.com/js/embed-collab-chat.min.js")
  end

  it "raises a clear error when target is missing" do
    expect { described_class.render(collab_spec, { "tenantId" => "demo" }) }
      .to raise_error(Liquid::Error, /fastcomments_collab_chat.*target/)
  end

  it "raises a clear error when target is empty" do
    expect { described_class.render(collab_spec, { "tenantId" => "demo", "target" => "" }) }
      .to raise_error(Liquid::Error, /fastcomments_collab_chat.*target/)
  end
end
