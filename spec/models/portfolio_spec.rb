require 'rails_helper'

RSpec.describe Portfolio, type: :model do
  context 'associations with dependency' do
    it { is_expected.to have_many(:transactions)}
    it { is_expected.to have_many(:stocks)}
  end

  describe "validates password" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:cash) }
  end
end
