require "liquid"

module FastComments
  module Jekyll
    class FastCommentsTag < ContainerTag
      def self.spec
        {
          container_tag: "div", container_id_prefix: "fc",
          script_path: "/js/embed-v2.min.js", script_marker_attr: "data-fc-embed",
          global_name: "FastCommentsUI", page_scoped: true
        }
      end
    end

    class CommentCountTag < ContainerTag
      def self.spec
        {
          container_tag: "span", container_id_prefix: "fc-count",
          script_path: "/js/widget-comment-count.min.js", script_marker_attr: "data-fc-count",
          global_name: "FastCommentsCommentCount", page_scoped: true
        }
      end
    end

    class LiveChatTag < ContainerTag
      def self.spec
        {
          container_tag: "div", container_id_prefix: "fc-live-chat",
          script_path: "/js/embed-live-chat.min.js", script_marker_attr: "data-fc-live-chat",
          global_name: "FastCommentsLiveChat", page_scoped: true
        }
      end
    end

    class CollabChatTag < SelectorTag
      def self.spec
        {
          script_path: "/js/embed-collab-chat.min.js", script_marker_attr: "data-fc-collab-chat",
          global_name: "FastCommentsCollabChat", shortcode_name: "fastcomments_collab_chat",
          page_scoped: true
        }
      end
    end

    class ImageChatTag < SelectorTag
      def self.spec
        {
          script_path: "/js/embed-image-chat.min.js", script_marker_attr: "data-fc-image-chat",
          global_name: "FastCommentsImageChat", shortcode_name: "fastcomments_image_chat",
          page_scoped: true
        }
      end
    end

    class RecentCommentsTag < ContainerTag
      def self.spec
        {
          container_tag: "div", container_id_prefix: "fc-recent-comments",
          script_path: "/js/widget-recent-comments-v2.min.js",
          script_marker_attr: "data-fc-recent-comments-v2",
          global_name: "FastCommentsRecentCommentsV2"
        }
      end
    end

    class RecentDiscussionsTag < ContainerTag
      def self.spec
        {
          container_tag: "div", container_id_prefix: "fc-recent-discussions",
          script_path: "/js/widget-recent-discussions-v2.min.js",
          script_marker_attr: "data-fc-recent-discussions-v2",
          global_name: "FastCommentsRecentDiscussionsV2"
        }
      end
    end

    class ReviewsSummaryTag < ContainerTag
      def self.spec
        {
          container_tag: "div", container_id_prefix: "fc-rs",
          script_path: "/js/embed-reviews-summary.min.js", script_marker_attr: "data-fc-reviews-summary",
          global_name: "FastCommentsReviewsSummaryWidget",
          use_callback: true, error_label: "Reviews Summary"
        }
      end
    end

    class TopPagesTag < ContainerTag
      def self.spec
        {
          container_tag: "div", container_id_prefix: "fc-top-pages",
          script_path: "/js/widget-top-pages-v2.min.js", script_marker_attr: "data-fc-top-pages-v2",
          global_name: "FastCommentsTopPagesV2"
        }
      end
    end

    class UserActivityFeedTag < UserActivityTag
      def self.spec
        {
          container_tag: "div", container_id_prefix: "fc-activity",
          script_path: "/js/embed-user-activity.min.js", script_marker_attr: "data-fc-user-activity",
          global_name: "FastCommentsUserActivity",
          use_callback: true, error_label: "User Activity"
        }
      end
    end

    class CommentCountBulkTag < BulkCountTag
      def self.spec
        {
          script_path: "/js/embed-widget-comment-count-bulk.min.js",
          script_marker_attr: "data-fc-count-bulk",
          global_name: "FastCommentsBulkCountConfig"
        }
      end
    end
  end
end

::Liquid::Template.register_tag("fastcomments", FastComments::Jekyll::FastCommentsTag)
::Liquid::Template.register_tag("fastcomments_comment_count", FastComments::Jekyll::CommentCountTag)
::Liquid::Template.register_tag("fastcomments_comment_count_bulk", FastComments::Jekyll::CommentCountBulkTag)
::Liquid::Template.register_tag("fastcomments_live_chat", FastComments::Jekyll::LiveChatTag)
::Liquid::Template.register_tag("fastcomments_collab_chat", FastComments::Jekyll::CollabChatTag)
::Liquid::Template.register_tag("fastcomments_image_chat", FastComments::Jekyll::ImageChatTag)
::Liquid::Template.register_tag("fastcomments_recent_comments", FastComments::Jekyll::RecentCommentsTag)
::Liquid::Template.register_tag("fastcomments_recent_discussions", FastComments::Jekyll::RecentDiscussionsTag)
::Liquid::Template.register_tag("fastcomments_reviews_summary", FastComments::Jekyll::ReviewsSummaryTag)
::Liquid::Template.register_tag("fastcomments_top_pages", FastComments::Jekyll::TopPagesTag)
::Liquid::Template.register_tag("fastcomments_user_activity_feed", FastComments::Jekyll::UserActivityFeedTag)
