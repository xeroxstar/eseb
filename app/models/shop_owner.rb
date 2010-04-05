# To change this template, choose Tools | Templates
# and open the template in the editor.

class ShopOwner < User
  default_scope :joins=>[:shop]
  validates_presence_of :first_name,:last_name,:social_id

  #
  #  def create_shop(attrs={})
  #  end

  # Check whether user is owner of shop

end
