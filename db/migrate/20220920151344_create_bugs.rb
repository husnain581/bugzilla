# frozen_string_literal: true

# Bugs Migration
class CreateBugs < ActiveRecord::Migration[5.2]
  def change
    create_table :bugs do |t|
      t.string :title, null: false
      t.string :description
      t.datetime :deadline
      t.integer :bug_type, null: false
      t.integer :status, null: false
      t.references :user, foreign_key: true, null: false
      t.references :project, foreign_key: true, null: false

      t.timestamps
    end
  end
end
