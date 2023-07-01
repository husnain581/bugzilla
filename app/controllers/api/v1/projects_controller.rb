# frozen_string_literal: true

module Api
  module V1
    # Projects Controller
    class ProjectsController < ApplicationController
      skip_before_action :authenticate_user!

      def index
        projects = Project.all
        render json: projects
      end

      def show
        project = Project.find_by(id: params[:id]) or not_found
        render json: project
      end
    end
  end
end
