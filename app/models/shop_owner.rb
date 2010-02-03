# To change this template, choose Tools | Templates
# and open the template in the editor.

class ShopOwner < User
  default_scope :conditions=>"first_name IS NOT NULL AND last_name IS NOT NULL
                               AND social_id IS NOT NULL AND city IS NOT NULL
                               AND country_id IS NOT NULL AND address IS NOT NULL"

end
