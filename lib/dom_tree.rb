Node = Struct.new(:type, :classes, :id, :name, :parent, :children, :value)

class DOMTree
  DOM_NODES = /(<.*?>)?(.+?)(?=<)(<\/.*?>)?/
  TYPE_RX = /<(.+?)( |>)/
  ATTR_RX = /([a-z_\-]+)=("|')([^'"]+)("|')/
  VOID_ELEMENTS = "area, base, br, col, command, embed, hr, img, input, keygen, link, meta, param, source, track, wbr".split(', ')

  def initialize
    @root = Node.new()
    @parent_stack = []
  end

  def build_tree(html)
    html.gsub(/\n/, '')
    nodes = html.scan(DOM_NODES)
    root = Node.new

    nodes.each do |arr|
      print arr
      build_node(arr)
    end

    @root # return root of dom
    # @root
  end

  private

  def build_node(arr)
    if arr[0] # if there is an opening tag
      node = parse_tag(arr[0]) # build a node for the tag
      set_parent_child(@parent_stack[-1], node)
      node.children = [] # it defaults to array child
      @parent_stack << node unless VOID_ELEMENTS.include?(node.type)# this becomes the next parent
    end

    unless arr[1].strip.empty?
      node = Node.new(nil, nil, nil, nil, @parent_stack[-1], nil, arr[1].strip) # make a new text node
      set_parent_child(@parent_stack[-1], node)
      # notable omission: do not set as parent
    end

    if arr[2]
      @root = @parent_stack.pop
    end
  end

  def parse_tag(str)
    type = str.match(TYPE_RX)[1]
    attrs = str.scan(ATTR_RX)
    attr_hash = Hash.new()

    attrs.each do |attribute|
      attr_hash[attribute[0]] = attribute[2]
    end

    attr_hash["class"] = attr_hash["class"].split(" ") if attr_hash["class"]

    Node.new(type, attr_hash["class"], attr_hash["id"], attr_hash["name"])
  end

  def set_parent_child(parent, child)
    if parent
      parent.children << child
      child.parent = parent
    end
  end
end
