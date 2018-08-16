# ProfileTypes possible values
class ProfileType < ActiveRecord::Base
  has_many :perfiles, inverse_of: :type, foreign_key: :type_id

  validates :valor, uniqueness: true, presence: true

  def self.default
    ProfileType.find_by valor: 'soil profile'
  end
end
