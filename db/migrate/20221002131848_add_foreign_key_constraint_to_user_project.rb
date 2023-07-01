# frozen_string_literal: true

# Migration to add foreign key null false

class AddForeignKeyConstraintToUserProject < ActiveRecord::Migration[5.2]
  # Added Birdge table foreign key constraint
  def change
    change_column_null(:user_projects, :user_id, false)
    change_column_null(:user_projects, :project_id, false)
  end
end
