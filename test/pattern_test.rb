require           'minitest/autorun'
require_relative  'test_helper.rb'

describe BulletML::Pattern do
  it 'loads a BulletML file' do
    p = BulletML::Pattern.new '../patterns/shoot0.xml'

    assert_equal  :bulletml,    p.data[:name]
    assert_equal  :horizontal,  p.data[:attributes][:type]
  end
end
