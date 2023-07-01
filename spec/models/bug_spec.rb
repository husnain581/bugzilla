# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bug, type: :model do
  describe 'relations' do
    it { is_expected.to belong_to(:project) }
    it { is_expected.to belong_to(:user).class_name('User') }
    it { is_expected.to belong_to(:assigned_to).class_name('User').optional }
    it { is_expected.to have_one_attached(:image) }
  end

  describe 'attributes' do
    it { is_expected.to have_db_column(:title).of_type(:string) }
    it { is_expected.to have_db_column(:description).of_type(:string) }
    it { is_expected.to have_db_column(:deadline).of_type(:datetime) }
    it { is_expected.to have_db_column(:bug_type).of_type(:integer) }
    it { is_expected.to have_db_column(:status).of_type(:integer) }
    it { is_expected.to have_db_index(:user_id) }
    it { is_expected.to have_db_index(:project_id) }
    it { is_expected.to have_db_index(:assigned_to_id) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:bug_type) }
    it { is_expected.to validate_presence_of(:status) }
  end

  describe 'have enum' do
    it { should define_enum_for(:bug_type).with_values(%i[feature bug]) }
    it { should define_enum_for(:status).with_values(%i[New started completed resolved]) }
  end

  it 'expected content type of profile img to be png, gif' do
    bug = create(:bug)
    expect(['image/png', 'image/gif']).to include(bug.image.blob.content_type)
  end

  it 'when it has featured status' do
    expect(Bug.status_for_feature).to eq([['Completed', 2]])
  end

  it 'when it has fix status' do
    expect(Bug.status_for_fix).to eq([['Resolved', 3]])
  end
end
