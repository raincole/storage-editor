class Device < ActiveRecord::Base
  belongs_to :app
  has_many :storages

  before_create :set_display_name

  def set_display_name
    self.display_name = self.uuid
  end
end
