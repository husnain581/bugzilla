# frozen_string_literal: true

class BugsController < ApplicationController
  before_action :set_bug, only: %i[show edit update destroy assign_bug bug_resolved]

  before_action :set_params_to_int, only: %i[create update]
  before_action :bug_type, only: %i[new edit]

  def new
    @project = Project.find_by(id: params[:project_id])
    @bug = @project.bugs.new
    authorize @bug
  end

  def show
    authorize @bug
  end

  def edit
    authorize @bug
  end

  def create
    @project = Project.find_by(id: params[:project_id])
    @bug = @project.bugs.new(bug_params)
    authorize @bug
    respond_to do |format|
      if @bug.save
        format.html { redirect_to bug_url(@bug), notice: t('.notice') }
      else
        format.html { redirect_to new_project_bug_path, alert: t('.alert') }
      end
    end
  end

  def update
    authorize @bug
    respond_to do |format|
      if @bug.update(bug_params)
        format.html { redirect_to bug_url(@bug), notice: t('.notice') }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def set_params_to_int
    params['bug']['status'] = params.dig('bug', 'status').to_i
    params['bug']['bug_type'] = params.dig('bug', 'bug_type').to_i
  end

  def update_dropdown
    dropdownfields = if params['type'] == '0'
                       Bug.status_for_feature
                     else
                       Bug.status_for_fix
                     end
    render json: { dropdownfields: dropdownfields }
  end

  def destroy
    authorize @bug
    @bug.destroy

    respond_to do |format|
      format.html { redirect_to projects_path, notice: t('.notice') }
    end
  end

  def assign_bug
    authorize @bug
    @bug.assigned_to = current_user
    @bug.save
    redirect_to bug_path, notice: t('.notice')
  end

  def bug_resolved
    authorize @bug
    @bug.update(status: 'resolved')
    redirect_to bug_path, notice: t('.notice')
  end

  private

  def set_bug
    @bug = Bug.find_by(id: params[:id]) or not_found
  end

  def bug_type
    @dropdownfields = Bug.statuses.reject { |key, value| [key.titleize, value] unless key != 'resolved' }
  end

  def bug_params
    params.require(:bug).permit(:title, :description, :deadline, :bug_type, :status, :image,
                                :assigned_to_id).with_defaults(user: current_user)
  end
end
