require           'minitest/autorun'
require_relative  'test_helper.rb'

describe BulletML::Pattern do
  it 'loads a BulletML file' do
    p = BulletML::Pattern.new '../patterns/shoot0.xml'
  end
end
