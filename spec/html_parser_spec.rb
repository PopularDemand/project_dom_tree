require 'rspec'
require 'html_parser'

describe HTMLParser do
  let(:html) { '<html> <head> </head> <body> <p> text node </p> </body> </html>' }
  let(:parser) { HTMLParser.new(html) }
  let(:root) { parser.html_root }

  describe '#new' do
    it 'stores the dom tree as a root node' do
      expect(parser.html_root).to be_a(Node)
    end
  end

  describe '#outputter' do
    it 'outputs the parent root tag' do
      expect{parser.outputter(root)}.to output(/<#{root.type}>/).to_stdout
    end

    it 'outputs the children open tags' do
      body = root.children[1]
      head = root.children[0]
      expect{parser.outputter(root)}.to output(/<#{head.type}>/).to_stdout
      expect{parser.outputter(root)}.to output(/<#{body.type}>/).to_stdout
    end

    it 'outputs the children close tags' do
      body = root.children[1]
      head = root.children[0]
      p parser.outputter(root)
      expect{parser.outputter(root)}.to output(/<\/#{head.type}>/).to_stdout
      expect{parser.outputter(root)}.to output(/<\/#{body.type}>/).to_stdout
    end
  end

  describe '#has_children?' do
    it 'correctly returns true if a node has children' do
      expect(parser.has_children?(root)).to be true
      expect(parser.has_children?(root.children[0])).to be false
    end
  end

  describe '#descendents' do
    it 'returns all descendents' do
      children =  parser.descendents(root).map do |child|
        child.type
      end
      expect(children.length).to eq(4)
    end
  end
end