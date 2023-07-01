# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'attributes' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:email).of_type(:string) }
    it { is_expected.to have_db_column(:user_type).of_type(:integer) }
  end

  describe 'relations' do
    it { is_expected.to have_many(:user_projects).dependent(:destroy) }
    it { is_expected.to have_many(:projects).through(:user_projects) }
    it { is_expected.to have_many(:bugs) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_length_of(:name).is_at_most(15) }
  end

  describe 'have enum' do
    it { should define_enum_for(:user_type).with_values(%i[developer manager qa]) }
  end

  it 'shuld have non manager users' do
    user = create(:user, user_type: :developer)
    expect(User.non_managers).to include(user)
  end
end
