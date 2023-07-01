# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  describe 'GET /projects' do
    context 'When user is logged in' do
      let(:manager_user) { create(:user) }
      before do
        sign_in manager_user
      end

      it 'should authorize to access index' do
        get :index
        expect(response).to have_http_status(200)
        expect(response).to render_template(:index)
        expect(assigns(:projects)).to eq manager_user.projects
      end
    end

    context 'When user is not logged in' do
      it 'should have not have access to index method' do
        get :index
        expect(response).to have_http_status(302)
        expect(response).not_to render_template('index')
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'should not assign any value to @projects' do
        project = create(:project)
        get :index
        expect(assigns(:projects)).not_to match_array([project])
      end
    end

    context 'when user is qa' do
      let(:qa_user) { create(:user, user_type: :qa) }
      before do
        sign_in qa_user
      end

      it 'all projects should be shown' do
        get :index
        expect(assigns(:projects)).to eq Project.all
      end
    end
  end

  describe 'GET /projects/new' do
    context 'When manager is logged in' do
      let(:manager_user) { create(:user) }
      before do
        sign_in manager_user
      end

      it 'assigns a new project and render new templete' do
        get :new
        expect(assigns(:project)).to be_a_new(Project)
        expect(response).to render_template('new')
      end
    end

    context 'When user is developer' do
      let(:developer_user) { create(:user, user_type: :developer) }
      before do
        sign_in developer_user
      end

      it 'assigns a new project and not render a new templete' do
        get :new
        expect(assigns(:project)).to be_a_new(Project)
        expect(response).not_to render_template('new')
      end
    end

    context 'When user is qa' do
      let(:qa_user) { create(:user, user_type: :qa) }
      before do
        sign_in qa_user
      end

      it 'assigns a new project and not render a new templete' do
        get :new
        expect(assigns(:project)).to be_a_new(Project)
        expect(response).not_to render_template('new')
      end
    end
  end

  describe 'POST /projects/create' do
    context 'When manager is logged in' do
      let(:manager_user) { create(:user) }
      before do
        sign_in manager_user
      end

      context 'with valid attributes' do
        it 'should assign a value to @project' do
          post :create, params: { project: attributes_for(:project) }
          expect(assigns(:project)).not_to eq nil
        end

        it 'Create a new project' do
          project_attributes = attributes_for(:project)
          expect { post :create, params: { project: project_attributes } }.to change(Project, :count).by(1)
          expect(assigns(:project).name).to eq project_attributes[:name]
          expect(flash[:notice]).to be_present
          expect(response).to redirect_to(projects_path)
        end
      end
    end

    context 'When user is developer' do
      let(:developer_user) { create(:user, user_type: :developer) }
      before do
        sign_in developer_user
      end

      context 'with valid attributes' do
        it 'should not assign and create a @project' do
          post :create, params: { project: attributes_for(:project) }
          expect(assigns(:project)).not_to eq nil
          expect { post :create, params: { project: attributes_for(:project) } }.to change(Project, :count).by(0)
          expect(flash[:alert]).to be_present
          expect(response).to redirect_to(projects_path)
        end
      end
    end

    context 'When user QA' do
      let(:qa_user) { create(:user, user_type: :qa) }
      before do
        sign_in qa_user
      end

      context 'with valid attributes' do
        it 'should not assign and create a @project' do
          post :create, params: { project: attributes_for(:project) }
          expect(assigns(:project)).not_to eq nil
          expect { post :create, params: { project: attributes_for(:project) } }.to change(Project, :count).by(0)
          expect(flash[:alert]).to be_present
          expect(response).to redirect_to(projects_path)
        end
      end
    end
  end

  describe 'GET /projects/:id' do
    let(:manager_user) { create(:user) }
    before do
      sign_in manager_user
    end

    let(:project) { create(:project) }
    context 'When user is manager' do
      it 'should have access to show method' do
        get :show, params: { id: project.id }
        expect(response).to have_http_status(200)
        expect(assigns(:project)).to eq project
        expect(response).to render_template('show')
      end
    end
  end

  describe 'GET /projects/:id/edit' do
    context 'when user is manager' do
      let(:manager_user) { create(:user) }
      before do
        sign_in manager_user
      end

      let(:project) { create(:project) }
      it 'should render a edit template' do
        get :edit, params: { id: project.id }
        expect(response).to render_template('edit')
        expect(assigns(:project)).to eq project
      end
    end

    context 'when user is qa' do
      let(:qa_user) { create(:user, user_type: :qa) }
      before do
        sign_in qa_user
      end

      let(:project) { create(:project) }
      it 'should render a edit template' do
        get :edit, params: { id: project.id }
        expect(response).not_to render_template('edit')
        expect(flash[:alert]).to have_content 'You are not authorized to perform this action.'
      end
    end

    context 'when user is developer' do
      let(:developer_user) { create(:user, user_type: :developer) }
      before do
        sign_in developer_user
      end

      let(:project) { create(:project) }
      it 'should not render a edit template' do
        get :edit, params: { id: project.id }
        expect(response).not_to render_template('edit')
        expect(flash[:alert]).to have_content 'You are not authorized to perform this action.'
      end
    end
  end

  describe 'PUT /projects/:id' do
    context 'When manager is logged in' do
      let(:manager_user) { create(:user) }
      before do
        sign_in manager_user
      end

      let(:new_project) { create(:project) }
      it 'Shoud update the requested project' do
        put :update, params: { project: { name: 'Twitter' }, id: new_project.id }
        expect(assigns(:project).name).to eq 'Twitter'
        expect(flash[:notice]).to have_content 'Project is updated successfully.'
      end
    end

    context 'When user is logged in as qa' do
      let(:qa_user) { create(:user, user_type: :qa) }
      before do
        sign_in qa_user
      end

      let(:new_project) { create(:project) }
      it 'Shoud not update the requested project' do
        put :update, params: { project: { name: 'Twitter' }, id: new_project.id }
        expect(assigns(:project).name).not_to eq 'Twitter'
        expect(flash[:alert]).to have_content 'You are not authorized to perform this action.'
      end
    end

    context 'When user is logged in as developer' do
      let(:developer_user) { create(:user, user_type: :developer) }
      before do
        sign_in developer_user
      end

      let(:new_project) { create(:project) }
      it 'Shoud not update the requested project' do
        put :update, params: { project: { name: 'Twitter' }, id: new_project.id }
        expect(assigns(:project).name).not_to eq 'Twitter'
        expect(flash[:alert]).to have_content 'You are not authorized to perform this action.'
      end
    end
  end

  describe 'POST ADD USER' do
    context 'When user is logged in' do
      let(:manager_user) { create(:user) }
      before do
        sign_in manager_user
      end

      let!(:project) { create(:project) }
      it 'should add user in project' do
        expect do
          post :add_user, params: { id: project.id, user_id: create(:user).id }
        end.to change(UserProject, :count).by(1)
      end
    end

    context 'When user is QA' do
      let(:qa_user) { create(:user, user_type: :qa) }
      before do
        sign_in qa_user
      end

      let!(:project) { create(:project) }
      it 'should not add user in project' do
        expect do
          post :add_user, params: { id: project.id, user_id: create(:user).id }
        end.to change(UserProject, :count).by(0)
      end
    end

    context 'When user is developer' do
      let(:developer_user) { create(:user, user_type: :developer) }
      before do
        sign_in developer_user
      end

      let!(:project) { create(:project) }
      it 'should not add user in project' do
        expect do
          post :add_user, params: { id: project.id, user_id: create(:user).id }
        end.to change(UserProject, :count).by(0)
      end
    end
  end

  describe 'DESTROY /projects/:id' do
    context 'When manager is logged in' do
      let(:manager_user) { create(:user) }
      before do
        sign_in manager_user
      end

      let!(:new_project) { create(:project) }
      it 'Shoud destroy the requested project' do
        expect { delete :destroy, xhr: true, params: { id: new_project.id } }.to change(Project, :count).by(-1)
      end
    end

    context 'When developer is logged in' do
      let(:developer_user) { create(:user, user_type: :developer) }
      before do
        sign_in developer_user
      end

      let!(:new_project) { create(:project) }
      it 'Shoud not destroy the requested project' do
        delete :destroy, params: { id: new_project.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'When qa is logged in' do
      let(:qa_user) { create(:user, user_type: :qa) }
      before do
        sign_in qa_user
      end

      let!(:new_project) { create(:project) }
      it 'Shoud not destroy the requested project' do
        delete :destroy, params: { id: new_project.id }
        expect(response).to have_http_status(302)
      end
    end
  end
end
