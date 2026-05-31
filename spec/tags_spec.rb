require "spec_helper"

RSpec.describe "FastComments Liquid tags" do
  let(:site_config) { { "url" => "https://example.com", "fastcomments" => { "tenant_id" => "demo" } } }
  let(:page) { { "url" => "/posts/hello/", "title" => "Hello" } }

  def render(source)
    render_tag(source, site_config: site_config, page: page)
  end

  it "registers all eleven tags" do
    %w[
      fastcomments fastcomments_comment_count fastcomments_comment_count_bulk
      fastcomments_live_chat fastcomments_collab_chat fastcomments_image_chat
      fastcomments_recent_comments fastcomments_recent_discussions
      fastcomments_reviews_summary fastcomments_top_pages fastcomments_user_activity_feed
    ].each do |name|
      expect(Liquid::Template.tags[name]).not_to be_nil, "expected #{name} to be registered"
    end
  end

  it "renders the comments widget with global tenant and page-derived urlId" do
    out = render("{% fastcomments %}")
    expect(out).to include('<div id="fc-testid0">')
    expect(out).to include("/js/embed-v2.min.js")
    expect(out).to include('"tenantId":"demo"')
    expect(out).to include('"urlId":"/posts/hello/"')
    expect(out).to include("window.FastCommentsUI")
  end

  it "lets a tag attribute override the page-derived urlId" do
    out = render('{% fastcomments url_id="custom" %}')
    expect(out).to include('"urlId":"custom"')
    expect(out).not_to include('"urlId":"/posts/hello/"')
  end

  it "renders the comment count widget as a span" do
    out = render("{% fastcomments_comment_count %}")
    expect(out).to include('<span id="fc-count-testid0">')
    expect(out).to include("/js/widget-comment-count.min.js")
  end

  it "renders the bulk comment count loader" do
    out = render("{% fastcomments_comment_count_bulk %}")
    expect(out).to include("window.FastCommentsBulkCountConfig=")
    expect(out).to include("/js/embed-widget-comment-count-bulk.min.js")
    # Bulk is site-wide: it must not carry a page-derived urlId.
    expect(out).not_to include('"urlId"')
  end

  it "renders the live chat widget" do
    out = render("{% fastcomments_live_chat %}")
    expect(out).to include("/js/embed-live-chat.min.js")
    expect(out).to include("window.FastCommentsLiveChat")
  end

  it "renders collab chat against a target selector" do
    out = render('{% fastcomments_collab_chat target="#post-body" %}')
    expect(out).to include('var target="#post-body";')
    expect(out).to include("/js/embed-collab-chat.min.js")
  end

  it "renders image chat against a target selector" do
    out = render('{% fastcomments_image_chat target="#hero" %}')
    expect(out).to include('var target="#hero";')
    expect(out).to include("/js/embed-image-chat.min.js")
  end

  it "renders recent comments and recent discussions" do
    expect(render("{% fastcomments_recent_comments %}")).to include("/js/widget-recent-comments-v2.min.js")
    expect(render("{% fastcomments_recent_discussions %}")).to include("/js/widget-recent-discussions-v2.min.js")
  end

  it "renders top pages" do
    expect(render("{% fastcomments_top_pages %}")).to include("/js/widget-top-pages-v2.min.js")
  end

  it "renders the reviews summary widget with callback wiring" do
    out = render("{% fastcomments_reviews_summary %}")
    expect(out).to include("/js/embed-reviews-summary.min.js")
    expect(out).to include("FastComments Reviews Summary Load Failure")
  end

  it "renders the user activity feed with callback wiring and userId" do
    out = render('{% fastcomments_user_activity_feed user_id="demo:u" %}')
    expect(out).to include("/js/embed-user-activity.min.js")
    expect(out).to include('"userId":"demo:u"')
    expect(out).to include("FastComments User Activity Load Failure")
  end

  it "site-wide widgets do not carry a page-derived urlId" do
    expect(render("{% fastcomments_top_pages %}")).not_to include('"urlId"')
    expect(render("{% fastcomments_recent_discussions %}")).not_to include('"urlId"')
  end

  it "selects the EU CDN via the region attribute" do
    out = render('{% fastcomments region="eu" %}')
    expect(out).to include("https://cdn-eu.fastcomments.com/js/embed-v2.min.js")
  end

  context "required attributes" do
    it "raises when collab chat has no target" do
      expect { render("{% fastcomments_collab_chat %}") }
        .to raise_error(Liquid::Error, /fastcomments_collab_chat.*target/)
    end

    it "raises when image chat has no target" do
      expect { render("{% fastcomments_image_chat %}") }
        .to raise_error(Liquid::Error, /fastcomments_image_chat.*target/)
    end

    it "raises when the user activity feed has no user_id" do
      expect { render("{% fastcomments_user_activity_feed %}") }
        .to raise_error(Liquid::Error, /fastcomments_user_activity_feed.*user_id/)
    end
  end
end
