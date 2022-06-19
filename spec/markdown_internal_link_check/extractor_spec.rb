# frozen_string_literal: true

RSpec.describe MarkdownInternalLinkCheck::Extractor do
  let!(:extractor) { MarkdownInternalLinkCheck::Extractor.new }

  describe "#extract" do
    it "returns an Array of uris" do
      string = <<~EOF
        ## index

        ### see https://github.github.com/gfm/#example-161

        [foo]: /url1 "title"

        [foo]

        ### see https://github.github.com/gfm/#example-413

        *foo [bar](/url2)*
      EOF
      expect(extractor.extract(string))
        .to eq([
          {
            start_line: 7,
            uri: URI('/url1'),
          },
          {
            start_line: 11,
            uri: URI('/url2'),
          },
        ])
    end
  end

  context "given absolute/relative URIs" do
    it "returns only relative links" do
      string = <<~EOF
        * [absolute](https://example.org/absolute)
        * [relative](/relative)
        * [relative](relative)
      EOF
      expect(extractor.extract(string))
        .to eq([
          {
            start_line: 2,
            uri: URI('/relative'),
          },
          {
            start_line: 3,
            uri: URI('relative'),
          },
        ])
    end
  end
end
