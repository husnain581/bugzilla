# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(15) }
  end

  describe 'relations' do
    it { is_expected.to have_many(:user_projects).dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:user_projects) }
    it { is_expected.to have_many(:bugs).dependent(:destroy) }
  end

  describe 'attributes' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
  end
end
