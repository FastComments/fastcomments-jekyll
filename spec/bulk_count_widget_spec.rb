require "spec_helper"

RSpec.describe FastComments::Jekyll::BulkCountWidget do
  let(:bulk_spec) do
    {
      script_path: "/js/embed-widget-comment-count-bulk.min.js",
      script_marker_attr: "data-fc-count-bulk",
      global_name: "FastCommentsBulkCountConfig"
    }
  end

  it "sets the global bulk config object with camelCase keys" do
    out = described_class.render(bulk_spec, { "tenantId" => "demo" })
    expect(out).to include('window.FastCommentsBulkCountConfig={"tenantId":"demo"};')
  end

  it "lazy-loads the bulk script once via the marker attribute" do
    out = described_class.render(bulk_spec, { "tenantId" => "demo" })
    expect(out).to include("https://cdn.fastcomments.com/js/embed-widget-comment-count-bulk.min.js")
    expect(out).to include('var marker="data-fc-count-bulk";')
    expect(out).to include("document.querySelector('script['+marker+']')")
  end

  it "honors the EU region for the script source" do
    out = described_class.render(bulk_spec, { "tenantId" => "demo", "region" => "eu" })
    expect(out).to include("https://cdn-eu.fastcomments.com/js/embed-widget-comment-count-bulk.min.js")
  end
end
