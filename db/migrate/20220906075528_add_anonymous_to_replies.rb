class AddAnonymousToReplies < ActiveRecord::Migration[7.0]
  def change
    add_column :replies, :anonymous, :boolean, default: true, null: false
  end
end
