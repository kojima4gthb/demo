class CreateInputs < ActiveRecord::Migration[5.0]
  def change
    drop_table :inputs
    create_table :inputs do |t|
      t.integer :inputid
      t.binary :icon

      t.timestamps
    end
  end
end
