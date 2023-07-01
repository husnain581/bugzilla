# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum user_type: { developer: 0,
                    manager: 1,
                    qa: 2 }
  validates :name, presence: true, length: { maximum: 15 }
  has_many :user_projects, dependent: :destroy
  has_many :projects, through: :user_projects
  has_many :bugs, dependent: :destroy
  scope :non_managers, -> { where.not(user_type: 'manager') }
  scope :available_users_for_project, ->(user_ids) { where.not(id: user_ids) }
end
