require_relative 'tag_parser'

DOM_NODES = /(<.*?>)?(.+?)(?=<)(<\/.*?>)?/

def store_tags(html)
  p html.scan(DOM_NODES)
  current_node = tag_parser(html)
end

# see open tag, put it on stack HTML
  # next open tags to stack
    # goes deeper into DOM
      # text block => node  ** no parser for text
    # close tag: create node of last item on stack
      # creating means defining parent/child
  # going back up the tree

html_string = "<div>  div text before  <p>    p text  </p>  <div>    more div text  </div>  div text after</div>"

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