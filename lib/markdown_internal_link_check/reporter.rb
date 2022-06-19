# frozen_string_literal: true

module MarkdownInternalLinkCheck
  class Reporter
    def report(files)
      exit_code = 0
      files.filter_map do |file|
        filepath = file[:filepath]

        file[:links].map do |link|
          unless link[:exist]
            exit_code += 1
            puts "#{filepath}:#{link[:start_line]}: #{link[:uri]}"
          end
        end
      end
      exit_code
    end
  end
end
