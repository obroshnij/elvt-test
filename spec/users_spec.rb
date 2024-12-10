require "rails_helper"

RSpec.describe Users do
  describe ".create" do
    let(:params) { { email: "test@email.com", password: "test123" } }
    let(:created_user) { build(:user) }
    let(:service_stub) do
      instance_double(Users::CreateService, user: created_user)
    end

    subject(:create) { described_class.create(**params) }

    it "calls service for user creation and returns a value" do
      expect(Users::CreateService).to receive(:call).with(params).once.and_return(service_stub)

      expect(create).to eq(created_user)
    end
  end

  describe ".create_game_event" do
    let(:params) do
      {
        user: user,
        game: game,
        event_type: "COMPLETED",
        occured_at: "2012-12-12T00:00:00Z"
      }
    end
    let(:user) { build(:user) }
    let(:game) { build(:game) }

    subject(:create_game_event) { described_class.create_game_event(**params) }

    it "calls service for user creation and returns a value" do
      expect(Users::CreateGameEventService).to receive(:call).with(params).once

      expect(create_game_event).to eq(nil)
    end
  end
end
