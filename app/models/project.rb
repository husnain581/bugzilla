# frozen_string_literal: true

class Project < ApplicationRecord
  validates :name, presence: true, length: { maximum: 15 }
  has_many :user_projects, dependent: :destroy
  has_many :users, through: :user_projects
  has_many :bugs, dependent: :destroy

  def unassigned_users
    User.non_managers.available_users_for_project(user_ids)
  end
end
