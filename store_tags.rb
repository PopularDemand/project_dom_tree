require_relative 'tag_parser'

DOM_NODES = /(<.*?>)?(.+?)(?=<)(<\/.*?>)?/

def store_tags(html)
  nodes = html.scan(DOM_NODES)

  parent_stack = []

  p nodes

  nodes.each do |arr|
    if arr[0]
      node = tag_parser(arr[0])
      node.parent = parent_stack[-1] if parent_stack[-1]
      parent_stack[-1].children = [] if parent_stack[-1]
      parent_stack[-1].children << node if parent_stack[-1]
    end

    if arr[1].strip.empty?
      # do nothing
    elsif arr[1]
      node = Node.new(nil, nil, nil, nil, parent_stack[-1], nil, arr[1].strip)
      node.value = arr[1].strip
      node.parent = parent_stack[-1]
      parent_stack[-1].children = [] if parent_stack[-1]
      parent_stack[-1].children << node if parent_stack[-1]
    end

    if arr[2].nil?
      parent_stack << node
    else
      root = parent_stack.pop
    end
  end

  root = nodes[0]
end

def set_parents_child
  # parent_stack[-1].children << node if parent_stack[-1]
end

# each
# if opening tag element[0], make node
  # set node.parent == parent_stack[-1]
  # if element[1].strip.empty? don't make a child node
  # else text element[1], make text node (child)
    # append it as child to parent.gsub("\n") { " " }
  # if element[2] == nil, node is a parent --> push into parent stack
  # if element[2], remove current parent from parent stack


test = " <body>
    <div class='top-div'>
      I'm an outer div!!!
      <div class='inner-div'>
        I'm an inner div!!! I might just <em>emphasize</em> some text.
      </div>
      I am EVEN MORE TEXT for the SAME div!!!
    </div>".gsub("\n") { " " }.gsub("  ") { " " }

html_string = test
puts " "
p store_tags(html_string)



# STACK:
# >top
# HTML

# >bottom

# TREE

# HTML>

#   BODY>

#     DIV > P > text

#     DIV