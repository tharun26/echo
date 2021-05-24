class AddUserIdToEndpoints < ActiveRecord::Migration[6.1]
  def change
    add_column :endpoints, :user_id, :integer
    add_foreign_key :endpoints, 
                    :users, 
                    column: :user_id
    add_index :endpoints, :user_id
  end
end
