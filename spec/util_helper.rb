module UtilHelper
  def be_redirect_to_home_page(warning_flash=nil)
    if warning_flash
      flash[:warning].should ==warning_flash
    else
      flash[:warning].should_not be_nil
    end
    response.should redirect_to('/')
  end
end