class DeviseAuthyAddToUsers < ActiveRecord::Migration[5.2]
  def self.up
    change_table :users do |t|
      t.string    :authy_id
      t.datetime  :last_sign_in_with_authy
      t.boolean   :authy_enabled, default: false
      t.boolean   :authy_hook_enabled, default: true
    end

    add_index :users, :authy_id
  end

  def self.down
    change_table :users do |t|
      t.remove :authy_id, :last_sign_in_with_authy, 
               :authy_enabled, authy_hook_enabled
    end
  end
end

