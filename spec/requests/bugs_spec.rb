# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BugsController, type: :controller do
  let(:project) { create(:project) }

  describe 'GET /bugs/new' do
    context 'When user is qa' do
      let(:qa_user) { create(:user, user_type: :qa) }
      before do
        sign_in qa_user
      end

      it 'should have access to new method' do
        get :new, params: { project_id: project.id }
        expect(assigns(:bug).project_id).to eq project.id
        expect(response).to have_http_status(200)
        expect(assigns(:bug)).to be_a_new(Bug)
        expect(response).to render_template('new')
      end
    end

    context 'When user is Manager' do
      let(:manager_user) { create(:user) }
      before do
        sign_in manager_user
      end

      it 'assigns a new bug and not render a new templete' do
        get :new, params: { project_id: project.id }
        expect(assigns(:bug)).to be_a_new(Bug)
        expect(flash[:alert]).to have_content 'You are not authorized to perform this action.'
        expect(response).not_to render_template('new')
      end
    end

    context 'When user is Developer' do
      let(:developer_user) { create(:user, user_type: :developer) }
      before do
        sign_in developer_user
      end

      it 'assigns a new project and not render a new templete' do
        get :new, params: { project_id: project.id }
        expect(assigns(:bug)).to be_a_new(Bug)
        expect(flash[:alert]).to have_content 'You are not authorized to perform this action.'
        expect(response).not_to render_template('new')
      end
    end

    context 'When user is not logged in' do
      it 'should not assigns a new bug and not render a new templete' do
        get :new, params: { project_id: project.id }
        expect(assigns(:bug)).not_to be_a_new(Bug)
        expect(flash[:alert]).to have_content 'You need to sign in or sign up before continuing.'
        expect(response).not_to render_template('new')
      end
    end
  end

  describe 'GET /bugs/:id' do
    context 'When user is manager' do
      let(:manager_user) { create(:user) }
      before do
        sign_in manager_user
      end

      let(:bug) { create(:bug) }
      it 'should assign a value to @bug and render show page' do
        get :show, params: { id: bug.id }
        expect(assigns(:bug)).to eq bug
        expect(response).to render_template('show')
      end
    end

    context 'When user is not logged in' do
      let(:bug) { create(:bug) }
      it 'should not assign a value to @bug and not render a show page' do
        get :show, params: { id: bug.id }
        expect(assigns(:bug)).not_to eq bug
        expect(flash[:alert]).to have_content 'You need to sign in or sign up before continuing.'
        expect(response).not_to render_template('show')
        expect(flash[:alert]).to have_content 'You need to sign in or sign up before continuing.'
      end
    end

    context 'When QA is logged in' do
      let(:qa_user) { create(:user, user_type: :qa) }
      before do
        sign_in qa_user
      end

      let(:bug) { create(:bug) }
      it 'should assign a value to @bug and render a show page' do
        get :show, params: { id: bug.id }
        expect(assigns(:bug)).to eq bug
        expect(response).to render_template('show')
      end
    end

    context 'When developer is logged in' do
      let(:developer_user) { create(:user, user_type: :developer) }
      before do
        sign_in developer_user
      end

      let(:bug) { create(:bug) }
      it 'should assign a value to @bug and render show page' do
        get :show, params: { id: bug.id }
        expect(assigns(:bug)).to eq bug
        expect(response).to render_template('show')
      end
    end
  end

  describe 'Get /bugs/edit' do
    context 'When user is not logged in' do
      it 'should not assign bugs to bugs' do
        get :edit, params: { id: create(:bug).id }
        expect(assigns(:bug)).to eq nil
        expect(response).not_to render_template(:edit)
        expect(flash[:alert]).to have_content 'You need to sign in or sign up before continuing.'
      end
    end

    context 'When user is qa' do
      let(:qa_user) { create(:user, user_type: :qa) }
      before do
        sign_in qa_user
      end

      it 'should assign bugs to bugs' do
        bug = create(:bug)
        get :edit, params: { id: bug.id }
        expect(assigns(:bug)).to eq bug
        expect(response).to render_template('edit')
      end
    end

    context 'When user is manager' do
      let(:manager_user) { create(:user) }
      before do
        sign_in manager_user
      end

      it 'should not assign bug to @bug' do
        bug = create(:bug)
        get :edit, params: { id: bug.id }
        expect(response).not_to render_template('edit')
        expect(flash[:alert]).to have_content 'You are not authorized to perform this action.'
      end
    end

    context 'When user is developer' do
      let(:developer_user) { create(:user, user_type: :developer) }
      before do
        sign_in developer_user
      end

      it 'should not assign bug to @bug' do
        bug = create(:bug)
        get :edit, params: { id: bug.id }
        expect(response).not_to render_template('edit')
        expect(flash[:alert]).to have_content 'You are not authorized to perform this action.'
      end
    end
  end

  describe 'DESTROY /bugs/:id' do
    context 'When user is qa' do
      let(:qa_user) { create(:user, user_type: :qa) }
      before do
        sign_in qa_user
      end

      let!(:new_bug) { create(:bug) }
      it 'Shoud destroy the requested bug' do
        expect { delete :destroy, xhr: true, params: { id: new_bug.id } }.to change(Bug, :count).by(-1)
      end
    end

    context 'When user is Developer' do
      let(:developer_user) { create(:user, user_type: :developer) }
      before do
        sign_in developer_user
      end

      let!(:new_bug) { create(:bug) }
      it 'Shoud  not destroy the requested bug' do
        expect { delete :destroy, xhr: true, params: { id: new_bug.id } }.to change(Bug, :count).by(0)
      end
    end

    context 'When user is manager' do
      let(:manager_user) { create(:user) }
      before do
        sign_in manager_user
      end

      let!(:new_bug) { create(:bug) }
      it 'Shoud not destroy the requested bug' do
        expect { delete :destroy, xhr: true, params: { id: new_bug.id } }.to change(Bug, :count).by(0)
      end
    end
  end

  describe 'PUT /bugs/:id' do
    context 'When user is qa' do
      let(:qa_user) { create(:user, user_type: :qa) }
      before do
        sign_in qa_user
      end

      let(:new_bug) { create(:bug) }
      it 'Shoud update the requested bug' do
        put :update,
            params: { bug: { title: 'Page Crash issue' }, id: new_bug.id, project_id: project.id }
        expect(assigns(:bug).title).to eq 'Page Crash issue'
        expect(flash[:notice]).to have_content 'Bug is updated successfully.'
      end
    end

    context ' When user is manager' do
      let(:manager_user) { create(:user) }
      before do
        sign_in manager_user
      end

      let(:new_bug) { create(:bug) }
      it 'Shoud update the requested project' do
        put :update,
            params: { bug: { title: 'Page Crash issue' }, id: new_bug.id, project_id: project.id }
        expect(new_bug.title).not_to eq 'Page Crash issue'
        expect(flash[:alert]).to have_content 'You are not authorized to perform this action.'
      end
    end

    context ' When user is developer' do
      let(:developer_user) { create(:user, user_type: :developer) }
      before do
        sign_in developer_user
      end

      let(:new_bug) { create(:bug) }
      it 'Shoud update the requested project' do
        put :update,
            params: { bug: { title: 'Page Crash issue' }, id: new_bug.id, project_id: project.id }
        expect(new_bug.title).not_to eq 'Page Crash issue'
        expect(flash[:alert]).to have_content 'You are not authorized to perform this action.'
      end
    end
  end

  describe 'POST /bugs/create' do
    context 'when user is qa' do
      let(:qa_user) { create(:user, user_type: :qa) }
      before do
        sign_in qa_user
      end

      it 'should create a new bug' do
        bug_attributes = attributes_for(:bug)
        expect { post :create, params: { bug: bug_attributes, project_id: project.id } }.to change(Bug, :count).by(1)
        expect(assigns(:bug).title).to eq bug_attributes[:title]
        expect(flash[:notice]).to have_content 'Bug created successfully'
      end
    end

    context 'When user is manager' do
      let(:manager_user) { create(:user) }
      before do
        sign_in manager_user
      end

      context 'with valid attributes' do
        it ' will not create a new bug' do
          expect do
            post :create,
                 params: {
                   bug: attributes_for(:bug), project_id: project.id
                 }
          end.to change(Bug, :count).by(0)
          expect(flash[:alert]).to have_content 'You are not authorized to perform this action.'
        end
      end
    end

    context 'When user is not logged in' do
      context 'with valid attributes' do
        it 'Create a new bug' do
          expect do
            post :create,
                 params: {
                   bug: attributes_for(:bug), project_id: project.id
                 }
          end.to change(Bug, :count).by(0)

          expect(flash[:alert]).to have_content 'You need to sign in or sign up before continuing.'
        end
      end
    end

    context 'When user is Developer' do
      let(:developer_user) { create(:user, user_type: :developer) }
      before do
        sign_in developer_user
      end

      context 'with valid attributes' do
        it 'Create a new bug' do
          expect do
            post :create,
                 params: {
                   bug: attributes_for(:bug), project_id: project.id
                 }
          end.to change(Bug, :count).by(0)

          expect(flash[:alert]).to have_content 'You are not authorized to perform this action.'
        end
      end
    end
  end

  describe 'POST assign bug' do
    context 'When user is Developer' do
      let(:developer_user) { create(:user, user_type: :developer) }
      before do
        sign_in developer_user
      end

      let(:bug) { create(:bug) }
      it 'should assign bug' do
        patch :assign_bug, params: { id: bug.id }
        expect(assigns(:bug).assigned_to).to eq developer_user
      end
    end

    context 'When user is manager' do
      let(:manager_user) { create(:user) }
      before do
        sign_in manager_user
      end

      let(:bug) { create(:bug) }
      it 'should not assign bug' do
        patch :assign_bug, params: { id: bug.id }
        expect(assigns(:bug).assigned_to).not_to eq manager_user
        expect(flash[:alert]).to have_content 'You are not authorized to perform this action.'
      end
    end

    context 'When user is qa' do
      let(:qa_user) { create(:user, user_type: :qa) }
      before do
        sign_in qa_user
      end

      let(:bug) { create(:bug) }
      it 'should not assign bug' do
        patch :assign_bug, params: { id: bug.id }
        expect(assigns(:bug).assigned_to).not_to eq qa_user
        expect(flash[:alert]).to have_content 'You are not authorized to perform this action.'
      end
    end
  end

  describe 'resolve a bug' do
    let(:bug) { create(:bug) }
    context 'When user is developer' do
      let(:developer_user) { create(:user, user_type: :developer) }
      before do
        sign_in developer_user
      end

      it 'bug status should be started when it is created' do
        patch :assign_bug, params: { id: bug.id }
        post :bug_resolved, params: { id: bug.id }
        expect(bug.status).to eq 'started'
      end
    end
  end
end
