require_relative 'tag_parser'

DOM_NODES = /(<.*?>)?(.+?)(?=<)(<\/.*?>)?/

def store_tags(html)
  p nodes = html.scan(DOM_NODES)
  # loop element
    # if element[0], run element[0] through tag parser put on stack -> run create_children(parent)

end

# see open tag, put it on stack HTML
  # next open tags to stack
    # goes deeper into DOM
      # text block => node  ** no parser for text
    # close tag: create node of last item on stack
      # creating means defining parent/child
  # going back up the tree

# loop or each
# if opening tag element[0], make node
	# set node.parent == parent_stack[-1]
  # if text element[1], make text node (child)
    # append it as child to parent
  # if element[2] == nil, node is a parent --> push into parent stack

  


html_string = "<div class='asdlfk' id='this'>  div text before  <p>    p text  </p>  <div>    more div text <p> p inside div </p> </div>  div text after</div>"

store_tags(html_string)



# STACK:
# >top
# HTML

# >bottom

# TREE

# HTML>

#   BODY>

#     DIV > P > text

#     DIV