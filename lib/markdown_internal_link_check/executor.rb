# frozen_string_literal: true

require_relative "extractor"
require_relative "reporter"

module MarkdownInternalLinkCheck
  class Executor
    class Error < ::StandardError; end
    class Unprocessable < Error; end

    private attr_reader :root_path

    def execute(root: nil, reporter: nil) # rubocop:disable Lint/UnusedMethodArgument
      set_root_path(root || ".")
      validate
      files = extract

      # リンク先があるかしらべる
      files.each do |file|
        check(file)
      end
      exit_code = Reporter.new.report(files)
      [files, exit_code]
    end

    private

    def extract
      root_path.glob("**/*.md").map do |pathname|
        next unless pathname.file? # TODO: test
        {
          filepath: pathname,
          links: Extractor.new.extract(pathname.read),
        }
      end
    end

    def set_root_path(object)
      @root_path ||= Pathname(object)
    end

    def validate
      root_path.exist? || raise(Unprocessable)
    end

    def check(file)
      filepath = file[:filepath]
      dir = filepath.parent
      file[:links].each do |link|
        pathname = Pathname(link[:uri].path)
        if pathname.relative?
          x = dir + pathname
          link[:exist] = x.exist?
        else
          x = root_path + ("." + pathname.to_s)
          link[:exist] = x.exist?
        end
      end
    end
  end
end
