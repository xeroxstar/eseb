require File.dirname(__FILE__) + '/../spec_helper'

describe Shop do
  fixtures :shops

  before(:each) do
    @shop_owner = stub_model(ShopOwner,{
        :login=>'quydoantran',
        :email=>'quydoantran@gmail.com'})
    @valid_attributes = {
      :name =>"Quynh Khanh",
      :shortname=>'quynhkhanh',
      :owner=>@shop_owner
    }
  end

  it "should create a new instance given valid attributes" do
    lambda{
      Shop.create(@valid_attributes)
    }.should change(Shop,:count).by(1)
  end
  describe "attributes" do

    it 'should have name' do
      create_shop({:name=>nil})
      @shop.errors.on(:name).should_not be_nil
    end

    it 'should have shortname' do
      create_shop({:shortname=>nil})
      @shop.errors.on(:shortname).should_not be_nil
    end

    it 'should not duplicate shortname' do
      lambda{
        create_shop({:shortname=>'quynhkhanh'})
        create_shop({:shortname=>'quynhkhanh'})
        @shop.errors.on(:shortname).should_not be_nil
      }.should_not change(Shop,:count).by(2)
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

    it 'should belong to a shopowner' do
      @shop.owner.should be_a_kind_of(ShopOwner)
    end

    it 'should have many products' do
      pending
    end

    it 'should have many categories' do
      pending
    end

  end # End describe asscociation

  def create_shop(attrs={})
    @valid_attributes = @valid_attributes.merge(attrs)
    @shop = Shop.create(@valid_attributes)
  end

end
