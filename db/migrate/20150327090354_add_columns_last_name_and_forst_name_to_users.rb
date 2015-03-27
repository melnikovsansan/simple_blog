class AddColumnsLastNameAndForstNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_name, :string, default_value: ''
    add_column :users, :first_name, :string, default_value: ''
  end
end
