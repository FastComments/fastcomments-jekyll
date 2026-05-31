module FastComments
  module Jekyll
    # Renders the bulk comment-count loader: sets the global config object, then
    # lazy-loads the bulk script once. The script scans the page for elements with
    # class "fast-comments-count" and a data-fast-comments-url-id attribute.
    module BulkCountWidget
      module_function

      def render(spec, config)
        clean = Util.sanitize_config(config)
        region = clean["region"]
        script_src = "#{Util.get_cdn_base(region)}#{spec[:script_path]}"

        "<script>" \
          "(function(){" \
          "window.#{spec[:global_name]}=#{Util.json_for_script(clean)};" \
          "var scriptSrc=#{Util.json_for_script(script_src)};" \
          "var marker=#{Util.json_for_script(spec[:script_marker_attr])};" \
          "if(!document.querySelector('script['+marker+']')){" \
          "var s=document.createElement('script');" \
          "s.src=scriptSrc;" \
          "s.setAttribute(marker,'');" \
          "document.head.appendChild(s);" \
          "}" \
          "})();" \
          "</script>"
      end
    end
  end
end
