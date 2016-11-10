Node = Struct.new(:type, :classes, :id, :name)
TYPE_RX = /<(.+?)( |>)/
ATTR_RX = /([a-z_\-]+)=("|')([^'"]+)("|')/

def tag_parser(str)

  type = str.match(TYPE_RX)[1]
  attrs = str.scan(ATTR_RX)
  attr_hash = Hash.new()

  attrs.each do |attribute|
    attr_hash[attribute[0]] = attribute[2]
  end

  attr_hash["class"] = attr_hash["class"].split(" ") if attr_hash["class"]

  Node.new(type, attr_hash["class"], attr_hash["id"], attr_hash["name"])
end

# t = tag_parser('<div class="foo bar" id="main" name="">')
# puts t.type
# p t.classes
# p t.id
# p t.name

# v = tag_parser("<div id = 'bim'>")
# puts v.type
# p v.classes
# p v.id