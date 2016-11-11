require 'rspec'
require 'DOMTree'

describe DOMTree do 

  let(:tree) { DOMTree.new() }
  let(:basic_html) { '<html> <head> </head> <body> <p> text node </p> </body> </html>' }
  let(:deep_children) { '<body> <div> <p id="first"> text node </p> <p class="second"> second text node </p> </div> </body>' }
  let(:broad_children) { '<body> <div > <p> text node </p> </div> <div id="second"> <p> text node </p> <p class="second"> second text node </p> </div> </body>' }
  let(:with_attributes) { '<body> <p class="bold first" id="main"> text node </p> </body>'}

  describe '#build tree' do
    it 'returns the root of the tree' do
      expect(tree.build_tree(basic_html)).to be_a(Node)
    end

    it 'correctly sets deep parent and child relationships' do
      root = tree.build_tree(deep_children)
      expect(root.children.length).to eq(1)
      div = root.children[0]
      expect(div.children.length).to eq(2)
    end

    it 'correctly set broad parent child relatoinships' do
      root = tree.build_tree(broad_children)
      expect(root.children.length).to eq(2)
      second_div = root.children[1]
      expect(second_div.children.length).to eq(2)
    end
    
    it 'captures the attrubutes' do
      root = tree.build_tree(with_attributes)
      para = root.children[0]
      expect(para.classes.length).to eq(2)
      expect(para.classes[1]).to eq("first")
      expect(para.id).to eq("main")
    end
  end
end