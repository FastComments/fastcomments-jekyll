require "liquid"

module FastComments
  module Jekyll
    # Shared Liquid::Tag lifecycle: parse markup -> resolve config -> render widget.
    # Concrete tags declare a `self.spec` and inherit one of the renderer bases below.
    class BaseTag < ::Liquid::Tag
      def render(context)
        attrs = AttributeParser.parse(@markup, context)
        config = ConfigResolver.resolve(context, attrs, derive_page_context: self.class.page_scoped?)
        render_widget(config)
      end

      def self.page_scoped?
        spec[:page_scoped] == true
      end

      def render_widget(_config)
        raise NotImplementedError, "#{self.class} must implement #render_widget"
      end
    end

    class ContainerTag < BaseTag
      def render_widget(config)
        ContainerWidget.render(self.class.spec, config)
      end
    end

    class SelectorTag < BaseTag
      def render_widget(config)
        SelectorWidget.render(self.class.spec, config)
      end
    end

    # The user activity feed is keyed by a user id rather than a page.
    class UserActivityTag < ContainerTag
      def render_widget(config)
        unless config["userId"].is_a?(String) && !config["userId"].empty?
          raise ::Liquid::SyntaxError, "fastcomments_user_activity_feed tag requires a \"user_id\" option."
        end

        super
      end
    end

    class BulkCountTag < BaseTag
      def render_widget(config)
        BulkCountWidget.render(self.class.spec, config)
      end
    end
  end
end
