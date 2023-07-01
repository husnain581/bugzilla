# frozen_string_literal: true

class AddIndexOnBugTitle < ActiveRecord::Migration[5.2]
  def change
    add_index :bugs, %i[title project_id], unique: true
  end
end
