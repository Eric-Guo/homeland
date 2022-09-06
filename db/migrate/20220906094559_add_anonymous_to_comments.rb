class AddAnonymousToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :anonymous, :boolean, default: true, null: false
  end
end
