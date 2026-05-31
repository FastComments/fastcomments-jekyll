require "spec_helper"

RSpec.describe FastComments::Jekyll::ContainerWidget do
  let(:comments_spec) do
    {
      container_tag: "div",
      container_id_prefix: "fc",
      script_path: "/js/embed-v2.min.js",
      script_marker_attr: "data-fc-embed",
      global_name: "FastCommentsUI"
    }
  end

  let(:reviews_spec) do
    {
      container_tag: "div",
      container_id_prefix: "fc-rs",
      script_path: "/js/embed-reviews-summary.min.js",
      script_marker_attr: "data-fc-reviews-summary",
      global_name: "FastCommentsReviewsSummaryWidget",
      use_callback: true,
      error_label: "Reviews Summary"
    }
  end

  let(:count_spec) do
    {
      container_tag: "span",
      container_id_prefix: "fc-count",
      script_path: "/js/widget-comment-count.min.js",
      script_marker_attr: "data-fc-count",
      global_name: "FastCommentsCommentCount"
    }
  end

  it "emits the exact loader markup (byte-for-byte port of 11ty)" do
    expected =
      "<div id=\"fc-testid0\"></div><script>(function(){" \
      "var containerId=\"fc-testid0\";" \
      "var config={\"tenantId\":\"demo\"};" \
      "var scriptSrc=\"https://cdn.fastcomments.com/js/embed-v2.min.js\";" \
      "var marker=\"data-fc-embed\";" \
      "var startedAt=Date.now();" \
      "var warned=false;" \
      "function schedule(){var elapsed=Date.now()-startedAt;if(elapsed>=5000&&!warned){warned=true;" \
      "console.warn(\"FastComments FastCommentsUI script did not load within 5s; continuing to retry every 1s.\");}" \
      "setTimeout(init,elapsed<5000?50:1000);}" \
      "function init(){var el=document.getElementById(containerId);" \
      "if(window.FastCommentsUI){window.FastCommentsUI(el,config);}else{schedule();}}" \
      "if(!document.querySelector('script['+marker+']')){" \
      "var s=document.createElement('script');" \
      "s.src=scriptSrc;" \
      "s.setAttribute(marker,'');" \
      "document.head.appendChild(s);}" \
      "init();})();</script>"

    expect(described_class.render(comments_spec, { "tenantId" => "demo" })).to eq(expected)
  end

  it "uses a span container when specified" do
    out = described_class.render(count_spec, { "tenantId" => "demo" })
    expect(out).to start_with('<span id="fc-count-testid0"></span>')
  end

  it "selects the EU CDN when region is eu" do
    out = described_class.render(comments_spec, { "tenantId" => "demo", "region" => "eu" })
    expect(out).to include("https://cdn-eu.fastcomments.com/js/embed-v2.min.js")
  end

  it "includes the camelCase config JSON" do
    out = described_class.render(comments_spec, { "tenantId" => "demo" })
    expect(out).to include('var config={"tenantId":"demo"};')
  end

  it "includes the script marker attribute" do
    out = described_class.render(comments_spec, { "tenantId" => "demo" })
    expect(out).to include('var marker="data-fc-embed";')
  end

  it "includes the slow-load warning text" do
    out = described_class.render(comments_spec, { "tenantId" => "demo" })
    expect(out).to include("did not load within 5s")
  end

  context "with useCallback widgets" do
    it "passes a node-style error callback and labelled console.error" do
      out = described_class.render(reviews_spec, { "tenantId" => "demo" })
      expect(out).to include("function(error){if(error){console.error(\"FastComments Reviews Summary Load Failure\",error);}}")
      expect(out).to include("FastComments Reviews Summary script did not load within 5s")
    end
  end

  context "with non-callback widgets" do
    it "does not pass an error callback" do
      out = described_class.render(comments_spec, { "tenantId" => "demo" })
      expect(out).not_to include("function(error)")
    end
  end
end
