# frozen_string_literal: true

module Api
  module V1
    # Bug Controller
    class BugsController < ApplicationController
      skip_before_action :authenticate_user!

      def index
        project = Project.find_by(id: params[:project_id]) or not_found
        bugs = project.bugs
        render json: bugs
      end

      def show
        bug = Bug.find_by(id: params[:id]) or not_found
        render json: bug
      end
    end
  end
end
