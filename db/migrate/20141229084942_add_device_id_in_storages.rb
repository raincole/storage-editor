class AddDeviceIdInStorages < ActiveRecord::Migration
  def change
    add_column :storages, :device_id, :integer
    add_index :storages, :device_id
  end
end
