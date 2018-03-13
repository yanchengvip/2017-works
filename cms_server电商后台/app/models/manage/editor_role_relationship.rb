class Manage::EditorRoleRelationship < ApplicationRecord
  belongs_to :editor
  belongs_to :role
end
