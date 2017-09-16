class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name, limit: 256, null: false
      t.string :mail, limit: 256
      t.string :password_digest, limit: 256, null: false
      t.string :remember_token, limit: 256
      t.string :keys, limit: 256

      t.timestamps
    end
  end
end
