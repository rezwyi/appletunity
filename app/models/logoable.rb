class Logoable < ActiveRecord::Base
  belongs_to :resource, polymorphic: true
  belongs_to :logo

  validates :resource, :logo, presence: true
end