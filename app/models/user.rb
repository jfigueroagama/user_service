class User < ActiveRecord::Base
  validates_uniqueness_of :name, :email
  validates_presence_of :name, :email
end
