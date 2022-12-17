def setup(args)
  puts 'setup!'
  hash  = args.gtk.parse_xml_file 'patterns/shoot0.xml'
  puts hash

  args.state.setup_done = true
end

def tick(args)
  setup(args) unless args.state.setup_done
end
