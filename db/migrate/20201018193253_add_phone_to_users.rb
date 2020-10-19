class AddPhoneToUsers < ActiveRecord::Migration[6.0]
  def self.up
    change_table :users do |t|
      t.string    :phone,  null: false, default: "" 
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :phone
    end
  end
end
