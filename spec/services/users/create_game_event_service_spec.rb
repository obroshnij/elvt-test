require "rails_helper"

module Users
  RSpec.describe CreateGameEventService do
    let!(:user) { create(:user) }
    let!(:game) { create(:game) }
    let(:event_type) { "COMPLETED" }
    let(:occured_at) { 1.day.ago.iso8601 }

    describe ".call" do
      subject(:call) { described_class.call(**params) }

      context "when params are valid" do
        let(:params) do
          {
            user: user,
            game: game,
            event_type: event_type,
            occured_at: occured_at
          }
        end

        it "creates user game event" do
          expect { call }.to change(user.user_game_events, :count).by(1)
        end
      end

      context "when occured_at is missing" do
        let(:params) do
          {
            user: user,
            game: game,
            event_type: event_type
          }
        end

        it "creates user game event" do
          expect { call }.to change(user.user_game_events, :count).by(1)

          expect(user.user_game_events.last).to have_attributes(
            game_id: game.id,
            occured_at: be_within(1.minute).of(Time.current)
          )
        end
      end

      context "when game is not passed" do
        let(:params) do
          {
            user: user,
            event_type: event_type
          }
        end

        it "creates user game event" do
          expect { call }.to raise_error(Users::Errors::GameEventDataIsNotValidError, "Validation failed: Game must exist, Game can't be blank")
        end
      end

      context "event type is not in the list" do
        let(:params) do
          {
            user: user,
            game: game,
            event_type: "DROP"
          }
        end

        it "creates user game event" do
          expect { call }.to raise_error(Users::Errors::GameEventDataIsNotValidError, "Validation failed: Game event type can't be blank, Game event type is not included in the list")
        end
      end

      context "when occured_at is not parseable" do
        let(:params) do
          {
            user: user,
            game: game,
            event_type: event_type,
            occured_at: "eron-don-don"
          }
        end

        it "creates user game event" do
          expect { call }.to raise_error(Users::Errors::GameEventDataIsNotValidError, "Date can not be parsed")
        end
      end
    end
  end
end
