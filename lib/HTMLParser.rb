Node = Struct.new(:type, :classes, :id, :name, :parent, :children, :value)
require_relative 'DOMTree'

class HTMLParser
  attr_reader :html_tree

  def initialize(html)
    @dom_tree = DOMTree.new
    @html_tree = @dom_tree.build_tree(html)
    @parent_stack = []
    @children_stack = []
  end

  def outputter(node)
    output_open_tag(node)
    output_text_node(node) unless node.value.nil?
    begin
      if has_children?(node) || node.type == 'html'
        @parent_stack << node
        collect_children(node)
      end
      if !has_children?(node)
        output_close_tag(node) if node.type && node.type != 'text'
      end
      if node.parent != @children_stack[-1].parent
        output_close_tag(node.parent)
        @parent_stack.pop
      end
      current_node = @children_stack.pop
      if !!current_node
        outputter(current_node)
      else
        @parent_stack.reverse.each { |parent| output_close_tag(parent) }
      end
    end until @children_stack.empty?
  end


  def has_children?(node)
    !!node.children && !node.children.empty?
  end

  def collect_children(parent)
    (parent.children.length - 1).downto(0) do |index|
      @children_stack << parent.children[index]
    end
    @children_stack
  end

  def output_open_tag(node)
    if node.type
      print "<#{node.type}"
      print " class='#{node.classes.join(' ')}'" if node.classes
      print " id='#{node.id}'" if node.id
      print " name='#{node.name}'" if node.name
      print ">\n"
    end
  end

  def output_text_node(node)
    puts node.value
  end

  def output_close_tag(node)
    # puts "</#{node.type}>" if node.type
    puts 'closed'
  end
end