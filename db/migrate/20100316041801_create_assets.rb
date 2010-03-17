class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table "assets", :force => true do |t|
      t.integer  "viewable_id"
      t.string   "viewable_type", :limit => 50
      t.string   "attachment_content_type"
      t.string   "attachment_file_name"
      t.integer  "attachment_file_size"
      t.integer  "position"
      t.string   "type", :limit => 75
      t.datetime "attachment_updated_at"
      t.integer  "attachment_width"
      t.integer  "attachment_height"
    end
  end

  def self.down
  end
end
