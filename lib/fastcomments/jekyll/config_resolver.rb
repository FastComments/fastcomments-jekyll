module FastComments
  module Jekyll
    # Merges widget config from three sources and camelizes the result.
    # Precedence (later wins): global _config.yml defaults < page-derived < tag attributes.
    module ConfigResolver
      module_function

      def resolve(context, attrs, derive_page_context: false)
        merged = {}

        global_config(context).each { |key, value| merged[key.to_s] = value }

        if derive_page_context
          derive(context).each { |key, value| merged[key] = value unless value.nil? }
        end

        attrs.each { |key, value| merged[key.to_s] = value }

        KeyMapper.map_keys(Util.sanitize_config(merged))
      end

      def global_config(context)
        site = site(context)
        return {} unless site

        config = site.config["fastcomments"]
        config.is_a?(Hash) ? config : {}
      end

      def derive(context)
        page = page(context)
        # Real Jekyll exposes `page` as a Liquid::Drop (Jekyll::Drops::DocumentDrop),
        # not a Hash; both answer page["url"]/page["title"], so guard on [] not Hash.
        return {} unless page.respond_to?(:[])

        derived = {}
        derived["url_id"] = page["url"] if page["url"]

        site = site(context)
        site_url = site ? site.config["url"] : nil
        derived["url"] = "#{site_url}#{page["url"]}" if site_url && !site_url.to_s.empty? && page["url"]

        derived["page_title"] = page["title"] if page["title"]
        derived
      end

      def site(context)
        registers = context.registers
        site = registers && registers[:site]
        site if site.respond_to?(:config)
      rescue StandardError
        nil
      end

      def page(context)
        context["page"]
      rescue StandardError
        nil
      end
    end
  end
end
