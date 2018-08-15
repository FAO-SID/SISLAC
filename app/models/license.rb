class License < ActiveRecord::Base
  has_many :perfiles, inverse_of: :license

  validates :name, presence: true, uniqueness: true
  validates :url, presence: true, uniqueness: true
  validates :acronym, presence: true, uniqueness: true
  validates :statement, presence: true, uniqueness: true
end
