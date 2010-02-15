require 'spec_helper'

describe Category do
  before(:each) do
    @valid_attributes = {
      :name=>'computer',
      :shortname=>'com'
    }
  end

  it "should create a new instance given valid attributes" do
    lambda{
      Category.create!(@valid_attributes)
    }.should change(Category,:count).by(1)
  end
  it 'require shortname' do
    lambda{
      @category = Category.new(:name=>'computer')
      @category.save
      @category.errors_on(:shortname).should_not be_nil
    }.should_not change(Category,:count)
  end
  it 'require name' do
    lambda{
      @category = Category.new(:shortname=>'computer')
      @category.save
      @category.errors_on(:name).should_not be_nil
    }.should_not change(Category,:count)
  end
end
