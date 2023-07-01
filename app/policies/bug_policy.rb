# frozen_string_literal: true

class BugPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def show?
    @user.present?
  end

  def new?
    @user.qa?
  end

  def edit?
    @user.qa?
  end

  def create?
    @user.qa?
  end

  def update?
    @user.qa?
  end

  def destroy?
    @user.qa?
  end

  def assign_bug?
    @user.developer?
  end

  def bug_resolved?
    @record.assigned_to == @user
  end
end
