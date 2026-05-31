module FastComments
  module Jekyll
    # Renders a selector widget that attaches to an existing element via a CSS
    # selector (collab chat, image chat). Port of renderSelectorWidget.
    module SelectorWidget
      module_function

      def render(spec, config)
        clean = Util.sanitize_config(config)
        target = clean["target"]

        unless target.is_a?(String) && !target.empty?
          raise Liquid::SyntaxError,
                "#{spec[:shortcode_name]} tag requires a \"target\" option (CSS selector for the target element)."
        end

        clean = clean.reject { |key, _| key == "target" }
        region = clean["region"]
        script_src = "#{Util.get_cdn_base(region)}#{spec[:script_path]}"

        global_name = spec[:global_name]
        slow_warn = "FastComments #{spec[:shortcode_name]} script did not load within 5s; continuing to retry every 1s."

        "<script>" \
          "(function(){" \
          "var target=#{Util.json_for_script(target)};" \
          "var config=#{Util.json_for_script(clean)};" \
          "var scriptSrc=#{Util.json_for_script(script_src)};" \
          "var marker=#{Util.json_for_script(spec[:script_marker_attr])};" \
          "var startedAt=Date.now();" \
          "var warned=false;" \
          "function schedule(){var elapsed=Date.now()-startedAt;" \
          "if(elapsed>=5000&&!warned){warned=true;console.warn(#{Util.json_for_script(slow_warn)});}" \
          "setTimeout(init,elapsed<5000?50:1000);}" \
          "function init(){if(window.#{global_name}){var el=document.querySelector(target);" \
          "if(el){window.#{global_name}(el,config);}}else{schedule();}}" \
          "if(!document.querySelector('script['+marker+']')){" \
          "var s=document.createElement('script');" \
          "s.src=scriptSrc;" \
          "s.setAttribute(marker,'');" \
          "document.head.appendChild(s);" \
          "}" \
          "init();" \
          "})();" \
          "</script>"
      end
    end
  end
end
