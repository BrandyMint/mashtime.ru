class Membership < ActiveRecord::Base

  def self.roles_collection
    roles = {}
    ROLES.each { |v| roles[v] = I18n.t "roles.#{v}" }
    roles
  end

  scope :last_updates, -> { order('updated_at desc') }
  scope :viewable, -> { order 'role_cd<2'}
  scope :ordered_by_role, -> { order :role_cd }
  scope :owners,  -> { where :role_cd => 0 }
  scope :viewers, -> { where :role_cd => 1 }
  scope :members, -> { where :role_cd => 2 }
  scope :supervisors, -> { where "role_cd=0 or role_cd=1" }

  belongs_to :user
  belongs_to :project

  as_enum :role, :owner => 0, :viewer => 1, :member => 2
  ROLES = self.roles.keys

  validates :user_id, :uniqueness => { :scope => :project_id }

end
