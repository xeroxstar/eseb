require File.dirname(__FILE__) + '/../spec_helper'

describe Shop do
  fixtures :shops

  before(:each) do
    @user = stub_model(User,{
        :login=>'quydoantran',
        :email=>'quydoantran@gmail.com'})
    @valid_attributes = {
      :name =>"Quynh Khanh",
      :shortname=>'quynhkhanh',
      :owner=>@user
    }
  end

  it "should create a new instance given valid attributes" do
    Shop.create!(@valid_attributes).should change(Shop,:count).by(1)
  end
  describe "attributes" do

    it 'should have name' do
      create_shop({:name=>nil})
      @shop.errors.on(:shortname).should_not be_nil
    end

    it 'should have shortname' do
      create_shop({:shortname=>nil})
      @shop.errors.on(:shortname).should_not be_nil
    end

    describe 'disallow illegimate shortname:' do
      ['asdsd.','asd123_','adsad-@as','asdsd_-asdsd','sfsd sdfsdf','a'].each do |shortname|
        it "'#{shortname}'" do
          lambda do
            create_shop(:shortname=>shortname)
            @shop.errors.on(:shortname).should_not be_nil
          end.should_not change(Shop,:count).by(1)
        end
      end
    end

    describe 'allow legimate shortname' do
      ['bac','quynhkhanh','quy-khanh','k177ys'].each do |shortname|
        it "'#{shortname}'" do
          lambda do
            create_shop(:shortname=>shortname)
            @shop.errors.on(:shortname).should be_nil
          end.should change(Shop,:count).by(1)
        end
      end
    end

  end # End describe attributes

  describe 'associations' do
    before(:each) do
      create_shop
    end

    it 'should belong to user and user should have enough personal info' do
      @shop.owner.should be_a_kind_of(User)
      @shop.owner.should be_enough_info
    end

    it 'should have many products' do
      pending
    end

    it 'should have many categories' do
      pending
    end

  end # End describe asscociation

  def create_shop(attrs={})
    @valid_attributes.merge(attrs)
    @shop = Shop.create(@valid_attributes)
  end

end
