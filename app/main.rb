require 'lib/rb_bulletml/pattern.rb'

def setup(args)
  puts 'setup!'
  #hash  = args.gtk.parse_xml_file 'patterns/shoot0.xml'
  #puts hash
  args.state.pattern  = BulletML::Pattern.new 'patterns/shoot0.xml'
  #p args.state.pattern

  args.state.setup_done = true
end

def tick(args)
  setup(args) unless args.state.setup_done
end
