require "json"
require "securerandom"

module FastComments
  module Jekyll
    # Low-level helpers ported from the fastcomments-11ty util.ts so the emitted
    # client JS is byte-equivalent.
    module Util
      module_function

      ESCAPE_FOR_SCRIPT = {
        "<" => "\\u003C",
        ">" => "\\u003E",
        "&" => "\\u0026",
        " " => "\\u2028",
        " " => "\\u2029"
      }.freeze

      # Escape the characters that can break out of an inline <script> body.
      def escape_for_script(str)
        str.to_s.gsub(/[<>&  ]/) { |c| ESCAPE_FOR_SCRIPT[c] }
      end

      # Escape a value for use inside a double-quoted HTML attribute (& first).
      def escape_attr(value)
        value.to_s
             .gsub("&", "&amp;")
             .gsub('"', "&quot;")
             .gsub("<", "&lt;")
             .gsub(">", "&gt;")
      end

      # JSON-encode a value for safe embedding in an inline <script>.
      def json_for_script(value)
        escape_for_script(JSON.generate(value))
      end

      def get_cdn_base(region)
        region.to_s == "eu" ? "https://cdn-eu.fastcomments.com" : "https://cdn.fastcomments.com"
      end

      # Drop nil values; keep scalars/arrays/hashes (mirrors the TS sanitizeConfig).
      def sanitize_config(config)
        return {} unless config.is_a?(Hash)

        config.each_with_object({}) do |(key, value), out|
          next if value.nil?

          out[key] = value
        end
      end

      # Container ids only need to be unique within a page.
      def make_container_id(prefix)
        "#{prefix}-#{SecureRandom.alphanumeric(7).downcase}"
      end
    end
  end
end
