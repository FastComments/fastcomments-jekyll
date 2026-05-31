module FastComments
  module Jekyll
    # Renders a container widget (a div/span placeholder + a self-contained loader
    # script). Port of renderContainerWidget from fastcomments-11ty.
    module ContainerWidget
      module_function

      def render(spec, config)
        clean = Util.sanitize_config(config)
        region = clean["region"]
        container_id = Util.make_container_id(spec[:container_id_prefix])
        script_src = "#{Util.get_cdn_base(region)}#{spec[:script_path]}"

        global_name = spec[:global_name]
        label = spec[:error_label] || global_name
        slow_warn = "FastComments #{label} script did not load within 5s; continuing to retry every 1s."

        init_body =
          if spec[:use_callback]
            failure = Util.json_for_script("FastComments #{label} Load Failure")
            "if(window.#{global_name}){window.#{global_name}(el,config,function(error){" \
              "if(error){console.error(#{failure},error);}});}else{schedule();}"
          else
            "if(window.#{global_name}){window.#{global_name}(el,config);}else{schedule();}"
          end

        tag = spec[:container_tag]

        "<#{tag} id=\"#{Util.escape_attr(container_id)}\"></#{tag}>" \
          "<script>" \
          "(function(){" \
          "var containerId=#{Util.json_for_script(container_id)};" \
          "var config=#{Util.json_for_script(clean)};" \
          "var scriptSrc=#{Util.json_for_script(script_src)};" \
          "var marker=#{Util.json_for_script(spec[:script_marker_attr])};" \
          "var startedAt=Date.now();" \
          "var warned=false;" \
          "function schedule(){var elapsed=Date.now()-startedAt;" \
          "if(elapsed>=5000&&!warned){warned=true;console.warn(#{Util.json_for_script(slow_warn)});}" \
          "setTimeout(init,elapsed<5000?50:1000);}" \
          "function init(){var el=document.getElementById(containerId);#{init_body}}" \
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
