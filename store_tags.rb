require_relative 'tag_parser'

DOM_NODES = /(<.*?>)?(.+?)(?=<)(<\/.*?>)?/

VOID_ELEMENTS = "area, base, br, col, command, embed, hr, img, input, keygen, link, meta, param, source, track, wbr".split(', ')

def store_tags(html)
  nodes = html.scan(DOM_NODES)
  root = Node.new()

  parent_stack = []

  nodes.each do |arr|
    if arr[0] # if there is an opening tag
      node = tag_parser(arr[0]) # build a node for the tag
      set_parent_child(parent_stack[-1], node)
      node.children = [] # it defaults to array child
      parent_stack << node unless VOID_ELEMENTS.include?(node.type)# this becomes the next parent
    end

    unless arr[1].strip.empty?
      node = Node.new(nil, nil, nil, nil, parent_stack[-1], nil, arr[1].strip) # make a new text node
      set_parent_child(parent_stack[-1], node)
      # notable omission: do not set as parent
    end

    if arr[2]
      root = parent_stack.pop
    end
  end

  root # return root of dom
end

def set_parent_child(parent, child)
  if parent
    parent.children << child
    child.parent = parent
  end
end

def outputter(node, children = [])
  output_open_tag(node) unless
  output_text_node(node) unless node.value.nil?
  parents = []
  begin
    if has_children?(node) || node.type == 'html'
      parents << node
      direct_children = collect_children(node)
      direct_children.each { |child| children << child }
      puts "working on #{node}"
      children.each do |child|
        puts "children: #{child.type}"
      end
      direct_children.each do |child|
        puts "direct_child: #{child.type}"
      end
    end
    current_node = children.pop
    if !!current_node
      outputter(current_node, children)
    end
  end until children.empty?
  parents.reverse.each { |parent| output_close_tag(parent) }
end

def collect_children(parent)
  children = []
  parent.children.length.times do |child|
    children << parent.children.pop
  end
  children
end

def output_open_tag(node)
  print "<#{node.type}"
  print " class='#{node.classes.join(' ')}'" if node.classes
  print " id='#{node.id}'" if node.id
  print " name='#{node.name}'" if node.name
  print ">\n"
end

def output_text_node(node)
  puts node.value
end

def output_close_tag(node)
  puts "</#{node.type}>"
end

def has_children?(node)
  !!node.children
end




test = "<body> <div class='class1 other'> <p> text node </p> </div> </body>".gsub(/\s{2,}/, " " )
test2 = %q|<html>
  <head>
    <title>
      This is a test page
    </title>
  </head>
  <body>
    <div class="top-div">
      I am an outer div!!!
      <div class="inner-div">
        I am an inner div!!! I might just <em>emphasize</em> some text.
      </div>
      I am EVEN MORE TEXT for the SAME div!!!
    </div>
    <main id="main-area">
      <header class="super-header">
        <h1 class="emphasized">
          Welcome to the test doc!
        </h1>
        <h2>
          This document contains data
        </h2>
      </header>
      <ul>
        Here is the data:
        <li>Four list items</li>
        <li class="bold funky important">One unordered list</li>
        <li>One h1</li>
        <li>One h2</li>
        <li>One header</li>
        <li>One main</li>
        <li>One body</li>
        <li>One html</li>
        <li>One title</li>
        <li>One head</li>
        <li>One doctype</li>
        <li>Two divs</li>
        <li>And infinite fun!</li>
      </ul>
    </main>
  </body>
</html>|.gsub(/\s{2,}/, " " )

# root = store_tags(test2)
root = store_tags(test2) # works. something wrong with recursion, not going deep enough.
outputter(root)

# set nodes logic
#each
# if opening tag element[0], make node
  # set node.parent == parent_stack[-1]
  # if element[1].strip.empty? don't make a child node
  # else text element[1], make text node (child)
    # append it as child to parent.gsub("\n") { " " }
  # if element[2] == nil, node is a parent --> push into parent stack
  # if element[2], remove current parent from parent stack

# outputter logic
# output parent
# collect_children if has_children?
  # put children on stack
    # pop one child
      # output tag
      # if has_children? 
        # put children on stack --> collect children
        # recurse
      # else
        # node to check = children stack.pop
      # end