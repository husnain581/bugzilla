# frozen_string_literal: true

# Migration to add reference to bug model
class AddDeveloperToBug < ActiveRecord::Migration[5.2]
  def change
    add_reference :bugs, :assigned_to
  end
end
