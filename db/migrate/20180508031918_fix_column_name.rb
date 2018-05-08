class FixColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :posts, :user_is, :user_id
  end
end
