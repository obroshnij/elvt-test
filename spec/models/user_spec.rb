require "rails_helper"

RSpec.describe User do
  let!(:user) { create(:user) }

  describe "#total_games_played" do
    subject(:total_games_played) { user.total_games_played }

    context "when user does not have games yet" do
      it { is_expected.to eq(0) }
    end

    context "when user has some games already" do
      let!(:played_games) { create_list(:user_game_event, 3, user: user) }

      it { is_expected.to eq(3) }
    end
  end
end
