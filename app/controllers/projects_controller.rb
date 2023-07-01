# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy remove_from_project add_user_modal add_user]

  def index
    @projects = if current_user.qa?
                  Project.all
                else
                  current_user.projects
                end
    authorize @projects
  end

  def show
    @bugs = @project.bugs
  end

  def new
    @project = Project.new
    authorize @project
  end

  def edit
    authorize @project
  end

  def create
    @project = Project.new(project_params)
    authorize @project

    respond_to do |format|
      if @project.save
        current_user.projects << @project
        format.html { redirect_to projects_path, notice: t('.notice') }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def remove_from_project
    @project.user_projects.find_by(user_id: params[:user_id]).destroy or not_found
    respond_to do |format|
      format.html { redirect_to projects_path, notice: t('.notice') }
    end
  rescue StandardError
    redirect_to projects_path, alert: t('.alert')
  end

  def add_user
    authorize @project
    @project.users << User.find_by(id: params[:user_id]) or not_found
    redirect_to projects_path, notice: t('.notice')
  rescue StandardError
    redirect_to projects_path, alert: t('.alert')
  end

  def add_user_modal
    authorize @project
    @users = @project.unassigned_users
    respond_to do |format|
      format.html { redirect_to projects_path(@project) }
      format.js
    end
  end

  def update
    authorize @project
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to project_url(@project), notice: t('.notice') }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @project
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url, notice: t('.notice') }
      format.json { head :no_content }
    end
  end

  private

  def set_project
    @project = Project.find_by(id: params[:id]) or not_found
  end

  def project_params
    params.require(:project).permit(:name)
  end
end
