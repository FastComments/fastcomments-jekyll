module FastComments
  module Jekyll
    # Maps snake_case tag/_config keys to the camelCase keys FastComments expects.
    module KeyMapper
      module_function

      def to_camel(key)
        str = key.to_s
        return str unless str.include?("_")

        parts = str.split("_")
        head = parts.shift
        head + parts.map { |part| part.empty? ? "" : part[0].upcase + part[1..] }.join
      end

      # Camelize top-level keys only; nested values (e.g. translations) pass through verbatim.
      def map_keys(hash)
        hash.each_with_object({}) { |(key, value), out| out[to_camel(key)] = value }
      end
    end
  end
end
