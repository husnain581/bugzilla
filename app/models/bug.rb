# frozen_string_literal: true

class Bug < ApplicationRecord
  has_one_attached :image
  validates :image, content_type: ['image/png', 'image/gif']
  validates :bug_type, :status, :title, presence: true
  validates :title, uniqueness: { scope: :project }
  belongs_to :project
  belongs_to :user
  belongs_to :assigned_to, class_name: :User, optional: true

  enum bug_type: {
    feature: 0,
    bug: 1
  }
  enum status: {
    New: 0,
    started: 1,
    completed: 2,
    resolved: 3
  }

  def self.status_for_feature
    Bug.statuses.filter_map { |key, value| [key.titleize, value] if key == 'completed' }
  end

  def self.status_for_fix
    Bug.statuses.filter_map { |key, value| [key.titleize, value] if key == 'resolved' }
  end
end
