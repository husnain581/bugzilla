class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :users
  has_many :bugs
end
