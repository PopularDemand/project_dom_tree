Node = Struct.new(:type, :classes, :id, :name, :parent, :children, :value)

class HTMLParser

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



  def has_children?(node)
    !!node.children
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
end