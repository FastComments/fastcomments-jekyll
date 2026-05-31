module FastComments
  module Jekyll
    # Parses a Liquid tag's markup ("k=v k='s' k=page.x") into a snake-keyed Hash.
    module AttributeParser
      module_function

      TOKEN_RE = /([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(?:"([^"]*)"|'([^']*)'|(\S+))/.freeze

      def parse(markup, context)
        result = {}
        return result if markup.nil?

        markup.scan(TOKEN_RE) do |key, double_quoted, single_quoted, bare|
          if !double_quoted.nil?
            result[key] = double_quoted
          elsif !single_quoted.nil?
            result[key] = single_quoted
          else
            value = coerce(bare, context)
            result[key] = value unless value.nil?
          end
        end

        result
      end

      # Unquoted values coerce to Integer/Float/Boolean/nil, else resolve as a
      # Liquid context variable (e.g. page.slug). Unresolved variables become nil.
      def coerce(token, context)
        case token
        when /\A-?\d+\z/ then Integer(token, 10)
        when /\A-?\d*\.\d+\z/ then Float(token)
        when "true" then true
        when "false" then false
        when "nil", "null" then nil
        else
          return nil if context.nil?

          begin
            context[token]
          rescue StandardError
            nil
          end
        end
      end
    end
  end
end
