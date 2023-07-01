class BugSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :deadline, :bug_type, :status, :image_url
  belongs_to :user
  belongs_to :assigned_to

  def image_url
    object.image.service_url if object.image.attached?
  end
end
