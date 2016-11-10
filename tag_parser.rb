Node = Struct.new(:type, :classes, :id, :name)
TYPE_RX = /<(.+?) /
ATTR_RX = /([a-z_\-]+)=("|')([^'"]+)("|')/
def tag_parser(str)


  type = str.match(TYPE_RX)
  attrs = str.scan(ATTR_RX)
  puts "attrs: #{attrs}"
  attr_hash = Hash.new( [] )

  attrs.each do |attribute|
    attr_hash[attribute[0]] << attribute[2]
  end

  puts "att hash: #{attr_hash}"

  Node.new(type, attr_hash["class"], attr_hash["id"], attr_hash["name"])
end

# "<p class='foo bar' id='baz' name='fozzie'>"

# "<div id = 'bim'>"

# # "<img src='http://www.example.com' title='funny things'>"
# type regex: /<(.+?) /
# attr regex: /[a-z_\-]+)=("|')([^'"]+)("|')/ (scan)
# [["src", "'", "http://www.example.com", "'"],
#  ["title", "'", "funny things", "'"]]

# <div class='foo bar' id='main' name=''>

t = tag_parser('<div class="foo bar" id="main" name="">')
# puts  t.type
# p t.classes
# p t.id