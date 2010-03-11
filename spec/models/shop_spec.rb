require File.dirname(__FILE__) + '/../spec_helper'

describe Shop do
  fixtures :users,:shops

  before(:each) do
    @shop_owner = users(:shopowner).becomes(ShopOwner)
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
      @shop.products.should_not be_nil
      @shop.products.should be_kind_of(Array)
    end

    it 'should have many categories' do
      @shop.categories.should_not be_nil
      @shop.categories.should be_kind_of(Array)
    end


  end # End describe asscociation

  describe 'util' do
    before(:each) do
      @shop = shops(:crazy_love)
    end

    it 'should be able to deactive' do
      @shop.deactivate
      @shop.should be_unactive
    end
    it 'should be able to reactive' do
      @shop.activate
      @shop.should_not be_unactive
    end
  end

  def create_shop(attrs={})
    @valid_attributes = @valid_attributes.merge(attrs)
    @shop = Shop.create(@valid_attributes)
  end

end
