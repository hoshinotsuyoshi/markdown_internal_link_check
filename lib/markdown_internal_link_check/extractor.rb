# frozen_string_literal: true

require "commonmarker"

module MarkdownInternalLinkCheck
  class Extractor
    def extract(string)
      doc = CommonMarker.render_doc(string)
      doc.walk.filter_map do |node|
        if node.type == :link
          uri = URI(node.url)
          if target?(uri)
            {
              start_line: node.sourcepos[:start_line],
              uri:
            }
          end
        end
      rescue URI::InvalidURIError
        next
      end
    end

    private def target?(uri)
      uri.relative?
    end
  end
end
