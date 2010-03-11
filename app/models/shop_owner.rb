# To change this template, choose Tools | Templates
# and open the template in the editor.

class ShopOwner < User
  default_scope :joins=>[:shop]
  validates_presence_of :first_name,:last_name,:address,:social_id,:country_id,:city
  has_one :shop, :foreign_key => 'user_id'


  def create_shop(attrs={})
  end

end
