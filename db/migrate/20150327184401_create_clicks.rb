class CreateClicks < ActiveRecord::Migration
  def change
    create_table :clicks do |t|
      t.string :browser
      t.string :os
      t.references :link, index: true

      t.timestamps null: false
    end
    add_foreign_key :clicks, :links
  end
end
