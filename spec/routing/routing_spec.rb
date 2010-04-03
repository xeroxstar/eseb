# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'routing' do
  ROUTES = {
    '/home'=>{:controller=>'home', :action=>'index'},
    '/logout'=>{:controller => 'sessions', :action => 'destroy'},
    '/login'=>{:controller => 'sessions', :action => 'new'},
    '/register'=>{:controller => 'users', :action => 'create'},
    '/signup'=>{:controller => 'users', :action => 'new'},
    '/activate/12321321'=> {:controller => 'users', :action => 'activate', :activation_code =>'12321321'},
    '/my_account'=>{:controller=>'users',:action=>'edit'},
    '/myshop'=>{:controller=>'shop_admin/my_shop', :action=>'index'}
  }
  describe "route generation" do
    ROUTES.each do |key,value|
      it "#{key}" do
        route_for(value).should == key
      end
    end
  end

  describe 'route recognition' do
    it 'root link' do
      params_from(:get, '/').should == {:controller => 'home', :action => 'index'}
    end
    describe 'Users Controller' do
      it "should generate params for users's index action from GET /users" do
        params_from(:get, '/users').should == {:controller => 'users', :action => 'index'}
        params_from(:get, '/users.xml').should == {:controller => 'users', :action => 'index', :format => 'xml'}
        params_from(:get, '/users.json').should == {:controller => 'users', :action => 'index', :format => 'json'}
      end

      it "should generate params for users's index action from GET /shop_owners" do
        params_from(:get, '/shop_owners').should == {:controller => 'users', :action => 'index'}
        params_from(:get, '/shop_owners.xml').should == {:controller => 'users', :action => 'index', :format => 'xml'}
        params_from(:get, '/shop_owners.json').should == {:controller => 'users', :action => 'index', :format => 'json'}
      end

      it "should generate params for users's new action from GET /users" do
        params_from(:get, '/users/new').should == {:controller => 'users', :action => 'new'}
        params_from(:get, '/users/new.xml').should == {:controller => 'users', :action => 'new', :format => 'xml'}
        params_from(:get, '/users/new.json').should == {:controller => 'users', :action => 'new', :format => 'json'}
      end

      it "should generate params for users's create action from POST /users" do
        params_from(:post, '/users').should == {:controller => 'users', :action => 'create'}
        params_from(:post, '/users.xml').should == {:controller => 'users', :action => 'create', :format => 'xml'}
        params_from(:post, '/users.json').should == {:controller => 'users', :action => 'create', :format => 'json'}
      end

      it "should generate params for users's show action from GET /users/1" do
        params_from(:get , '/users/1').should == {:controller => 'users', :action => 'show', :id => '1'}
        params_from(:get , '/users/1.xml').should == {:controller => 'users', :action => 'show', :id => '1', :format => 'xml'}
        params_from(:get , '/users/1.json').should == {:controller => 'users', :action => 'show', :id => '1', :format => 'json'}
      end

      it "should generate params  for users's update from PUT /users/update" do
        params_from(:put , '/users/1').should == {:controller => 'users', :action => 'update',:id=>'1'}
        params_from(:put , '/users/1.xml').should == {:controller => 'users', :action => 'update', :format => 'xml',:id=>'1'}
        params_from(:put , '/users/1.json').should == {:controller => 'users', :action => 'update', :format => 'json',:id=>'1'}
      end

      it "should generate params for users's destroy action from DELETE /users/1" do
        params_from(:delete, '/users/1').should == {:controller => 'users', :action => 'destroy', :id => '1'}
        params_from(:delete, '/users/1.xml').should == {:controller => 'users', :action => 'destroy', :id => '1', :format => 'xml'}
        params_from(:delete, '/users/1.json').should == {:controller => 'users', :action => 'destroy', :id => '1', :format => 'json'}
      end

      it "should generate params for users's edit action from GET /my_account" do
        params_from(:get, '/my_account').should == {:controller => 'users', :action => 'edit'}
        params_from(:get, '/my_account.xml').should == {:controller => 'users', :action => 'edit', :format => 'xml'}
        params_from(:get, '/my_account.json').should == {:controller => 'users', :action => 'edit', :format => 'json'}
      end

      it "should generate params for users's suspend action from PUT /users/1/suspend" do
        params_from(:put, '/users/1/suspend').should == {:controller => 'users', :action => 'suspend',:id=>'1'}
        params_from(:put, '/users/1/suspend.xml').should == {:controller => 'users', :action => 'suspend', :id=>'1', :format => 'xml'}
        params_from(:put, '/users/1/suspend.json').should == {:controller => 'users', :action => 'suspend', :id=>'1', :format => 'json'}
      end

      it "should generate params for users's unsuspend action from PUT /users/1/unsuspend" do
        params_from(:put, '/users/1/unsuspend').should == {:controller => 'users', :action => 'unsuspend',:id=>'1'}
        params_from(:put, '/users/1/unsuspend.xml').should == {:controller => 'users', :action => 'unsuspend', :id=>'1', :format => 'xml'}
        params_from(:put, '/users/1/unsuspend.json').should == {:controller => 'users', :action => 'unsuspend', :id=>'1', :format => 'json'}
      end

    end
    describe 'Shops' do
      it "should generate params for shops's index from /shops" do
        params_from(:get, '/shops').should == {:controller => 'shops', :action => 'index'}
      end

      it "should generate params for shops's show from /shops/1" do
        params_from(:get, '/shops/1').should == {:controller => 'shops', :action => 'show',:id=>'1'}
      end

      it "should generate params for shops's edit from /shops/1" do
        params_from(:get, '/shops/1/edit').should == {:controller => 'shops', :action => 'edit',:id=>'1'}
      end

      it "should generate params for shops's update from /shops/1" do
        params_from(:put, '/shops/1').should == {:controller => 'shops', :action => 'update',:id=>'1'}
      end

      it "should generate params for shops's new from /shops/new" do
        params_from(:get, '/shops/new').should == {:controller => 'shops', :action => 'new'}
      end
      it "should generate params for shops's create from /shops" do
        params_from(:post, '/shops').should == {:controller => 'shops', :action => 'create'}
      end
    end

    describe 'shop_admin' do
      describe 'products' do
        it 'index should from GET /shop_admin/products' do
          params_from(:get,'/shop_admin/products').should == {:controller=>'shop_admin/products', :action=>'index'}
        end
        it 'new should from GET /shop_admin/products/new' do
          params_from(:get,'/shop_admin/products/new').should == {:controller=>'shop_admin/products', :action=>'new'}
        end
        it 'create should from POST /shop_admin/products' do
          params_from(:post,'/shop_admin/products').should == {:controller=>'shop_admin/products', :action=>'create'}
        end
        it 'edit should from GET /shop_admin/products/1/edit' do
          params_from(:get,'/shop_admin/products/1/edit').should == {:controller=>'shop_admin/products', :action=>'edit',:id=>'1'}
        end
        it 'update should from PUT /shop_admin/products/1' do
          params_from(:put,'/shop_admin/products/1').should == {:controller=>'shop_admin/products', :action=>'update',:id=>'1'}
        end
        it 'destroy should from DELETE /shop_admin/products/1' do
          params_from(:delete,'/shop_admin/products/1').should == {:controller=>'shop_admin/products', :action=>'destroy',:id=>'1'}
        end
      end
      describe 'shop' do
        it 'show should from GET /shop_admin/shop' do
          params_from(:get,'/shop_admin/shop').should == {:controller=>'shop_admin/my_shop', :action=>'show'}
        end
        it 'new  should from GET /shop_admin/shop/new' do
          params_from(:get,'/shop_admin/shop/new').should == {:controller=>'shop_admin/my_shop', :action=>'new'}
        end
        it 'edit should from GET /shop_admin/shop/edit' do
          params_from(:get,'/shop_admin/shop/edit').should == {:controller=>'shop_admin/my_shop', :action=>'edit'}
        end
        it 'create should from POST /shop_admin/shop' do
          params_from(:post,'/shop_admin/shop').should == {:controller=>'shop_admin/my_shop', :action=>'create'}
        end
        it 'update should from PUT /shop_admin/shop' do
          params_from(:put,'/shop_admin/shop').should == {:controller=>'shop_admin/my_shop', :action=>'update'}
        end
        it 'deactive should from PUT /shop_admin/shop/deactive' do
          params_from(:put,'/shop_admin/shop/deactive').should == {:controller=>'shop_admin/my_shop', :action=>'deactive'}
        end
        it 'reactive should from PUT /shop_admin/shop/reactive' do
          params_from(:put,'/shop_admin/shop/reactive').should == {:controller=>'shop_admin/my_shop', :action=>'reactive'}
        end
      end
    end
  end

  describe 'named routing' do
    it 'logout_path' do
      logout_path.should == '/logout'
    end

    it 'login_path' do
      login_path.should == '/login'
    end

    it 'register_path' do
      register_path.should == '/register'
    end

    it 'signup_path' do
      signup_path.should == '/signup'
    end

    it 'my_shop_path' do
      my_shop_path.should == '/myshop'
    end

    it "should route my_account_path to /my_account" do
      my_account_path().should == "/my_account"
      my_account_path(:format => 'xml').should == "/my_account.xml"
      my_account_path(:format => 'json').should == "/my_account.json"
    end

    it "should route shop_owner_path to /users" do
      shop_owners_path().should == "/shop_owners"
      shop_owners_path(:format => 'xml').should == "/shop_owners.xml"
      shop_owners_path(:format => 'json').should == "/shop_owners.json"
    end

  end
end