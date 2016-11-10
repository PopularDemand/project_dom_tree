def tag_parser


end

# "<p class='foo bar' id='baz' name='fozzie'>"

# "<div id = 'bim'>"

# "<img src='http://www.example.com' title='funny things'>"

Node = Struct.new(:type, :classes, :id, :name)

regex: /<(.+?) /
<div class='foo bar'>