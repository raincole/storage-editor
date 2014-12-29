class Storage < ActiveRecord::Base
  serialize :data, JSON

  belongs_to :device
  belongs_to :schema

  before_save :touch_changed_at

  def touch_changed_at
    self.changed_at = DateTime.now if self.changed?
  end
end
