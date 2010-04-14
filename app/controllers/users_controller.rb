class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  # include AuthenticatedSystem

  # Protect these actions behind an admin login
  # before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :find_user, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :login_required , :only=>[:edit,:update,:suspend,:unsuspend]

  # render new.rhtml
  def new
    @user = User.new
  end

  def edit
    @user = current_user
    @address = current_user.address || Address.new
  end

  def update
    @user = current_user
    params[:user] ||= params[:shop_owner]
    if @user.update_attributes(params[:user])
      flash[:notice] = 'Update successfull'
    end
    @address = current_user.address || Address.new
    render :action=>:edit
  end

  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    if facebook_session
      @user.fb_id = facebook_session.user.uid.to_i
      @user.connect_fb!
    else
      @user.register! if @user && @user.valid?
    end
    success = @user && @user.valid?
    if success && @user.errors.empty?
      if @user.active?
        redirect_to(my_account_path)
        return
      end
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
      redirect_back_or_default('/')
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end

  def suspend
    current_user.suspend!
    redirect_to users_path
  end

  def unsuspend
    current_user.unsuspend!
    redirect_to users_path
  end

  #  def destroy
  #    @user.delete!
  #    redirect_to users_path
  #  end

  # only admin can do this action
  #  def purge
  #    @user.destroy
  #    redirect_to users_path
  #  end

  # There's no page here to update or destroy a user.  If you add those, be
  # smart -- make sure you check that the visitor is authorized to do so, that they
  # supply their old password along with a new one to update it, etc.
  def link_user_accounts
    if current_user
      current_user.activate! if current_user.pending?
      self.current_user.link_fb_connect(facebook_session.user.id) unless self.current_user.fb_id == facebook_session.user.id
      redirect_back_or_default(my_account_path)
    else
      redirect_to(new_user_path)
    end
  end

  protected
  def find_user
    @user = User.find(params[:id])
  end

end