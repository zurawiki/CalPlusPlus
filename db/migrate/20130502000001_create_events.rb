class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :title
      t.string :color
      t.decimal :importance
      t.boolean :autoImportance
      t.integer :user_id
      t.string :location

      t.boolean :allDay
      t.datetime :start
      t.datetime :end

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
