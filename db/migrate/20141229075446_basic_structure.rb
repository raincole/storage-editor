class BasicStructure < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.string :name, :null => false
    end

    create_table :devices do |t|
      t.integer :app_id, :null => false
      t.string :uuid, :null => false
      t.string :display_name

      t.timestamps
    end
    add_index :devices, [:app_id, :uuid], :unique => true
    add_index :devices, :app_id

    create_table :schemas do |t|
      t.integer :app_id, :null => false
      t.string :name, :null => false
      t.text :schema, :limit => 10000

      t.timestamps
    end
    add_index :schemas, [:app_id, :name], :unique => true

    create_table :storages do |t|
      t.integer :schema_id, :null => false
      t.text :data, :limit => 10000
      t.datetime :changed_at

      t.timestamps
    end
    add_index :storages, [:schema_id]
  end
end
