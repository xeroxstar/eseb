class Asset < ActiveRecord::Base
  belongs_to :viewable, :polymorphic => true
  acts_as_list :scope => :viewable
  named_scope :with_ids , lambda{ |ids|
    {
      :conditions=>{:id=>ids}
    }
  }
end