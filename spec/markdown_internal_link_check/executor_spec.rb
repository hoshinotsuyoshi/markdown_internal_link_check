# frozen_string_literal: true

RSpec.describe MarkdownInternalLinkCheck::Executor do
  let!(:executor) { MarkdownInternalLinkCheck::Executor.new }

  context "given directory which does not exist" do
    it "raises" do
      expect { executor.execute(root: "spec/files/noplace") }
        .to raise_error(MarkdownInternalLinkCheck::Executor::Unprocessable)
    end
  end

  context "given empty directory" do
    it "returns an empty Array and exit code integer" do
      expect(executor.execute(root: "spec/files/example001"))
        .to eq([[], 0])
    end
  end

  context "given a directory with a *.md" do
    it "returns an Array and exit code integer" do
      expect(executor.execute(root: "spec/files/example002"))
        .to eq([[
          filepath: Pathname("spec/files/example002/index.md"),
          links: [
            {
              exist: false,
              start_line: 7,
              uri: URI('/url1'),
            },
            {
              exist: false,
              start_line: 11,
              uri: URI('/url2.md'),
            },
            {
              exist: false,
              start_line: 13,
              uri: URI('./url4.md'),
            },
          ],
        ], 3])
    end
  end

  context "given a directory with a *.md" do
    it "returns an Array and exit code integer" do
      expect(executor.execute(root: "spec/files/example003"))
        .to eq([[
          {
            filepath: Pathname("spec/files/example003/dir1/index.md"),
            links: [
              {
                exist: false,
                start_line: 5,
                uri: URI('./foo.md'),
              },
              {
                exist: true,
                start_line: 6,
                uri: URI('../dir2/foo.md'),
              },
            ],
          },
          {
            filepath: Pathname("spec/files/example003/dir2/foo.md"),
            links: [],
          },
        ], 1])
    end
  end
end
