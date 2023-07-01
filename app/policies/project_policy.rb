# frozen_string_literal: true

class ProjectPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def index?
    @user.present?
  end

  def new
    check_authenticity?
  end

  def create?
    check_authenticity?
  end

  def update?
    check_authenticity?
  end

  def edit?
    check_authenticity?
  end

  def destroy?
    check_authenticity?
  end

  def check_authenticity?
    @user.manager?
  end

  def remove_from_project?
    check_authenticity?
  end

  def add_user_modal?
    check_authenticity?
  end

  def add_user?
    check_authenticity?
  end
end
