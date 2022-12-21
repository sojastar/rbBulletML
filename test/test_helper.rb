require 'rexml/document'

require_relative '../lib/rb_bulletml/pattern.rb'

class GTK
  attr_accessor :args

  def initialize
    @args = Args.new
  end

  def read_file(filename)
    File.read filename
  end

  def parse_xml(xml_string)
    xml = REXML::Document.new xml_string
    parse_xml_element xml.root 
  end

  def parse_xml_file(filename)
    xml_string = ""
    File.open(filename, 'r') { |file| xml_string = file.read }
    parse_xml xml_string
  end

  def parse_xml_element(element)
    if element.class == REXML::Text then
      (/\n/ =~ element.value).nil? ? { :type => :content, :data => element.value } : nil

    else
      { :type       => :element,
        :name       => element.name,
        :attributes => element.attributes.to_a.map { |a| [ a.name, a.value ] }.to_h,
        :children   => element.children.map { |c| parse_xml_element(c) }.compact }
    end
  end
end

