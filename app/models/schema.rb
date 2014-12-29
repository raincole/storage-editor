class Schema < ActiveRecord::Base
  serialize :schema, JSON

  belongs_to :app
  has_many :storages
end
