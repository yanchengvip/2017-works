class Role < ApplicationRecord
  validates :name, uniqueness: true, presence: true

  has_many :admin_roles, -> { where(delete_flag: false) }, dependent: :destroy
  has_many :admins, through: :admin_roles
  has_many :role_authority_resources, -> { where(delete_flag: false) }, dependent: :destroy
  has_many :authority_resources,through: :role_authority_resources
  after_create :generate_en_name

  private


  def generate_en_name
    en_name = MyUtils.generate_code self.id
    self.update_attributes!(en_name: en_name)
  end
end
