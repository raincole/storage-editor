class App < ActiveRecord::Base
  has_many :schemas
  has_many :devices
end
