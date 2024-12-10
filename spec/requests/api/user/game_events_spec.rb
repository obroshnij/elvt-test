require "rails_helper"

RSpec.describe "api/user/game_events" do
  let!(:user) { create(:user) }
  let!(:game) { create(:game) }

  let(:path) { "/api/user/game_events" }

  include_context "with authenticated request"

  describe "POST" do
    subject(:make_request) { post path, params: params, headers: auth_headers }

    context "when user is not authorized" do
      let(:auth_headers) { {} }

      let(:params) do
        {
          game_event: {
            type: "COMPLETED",
            occured_at: "2012-12-12T00:00:00Z",
            game_id: game.id
          }
        }
      end

      it "responds with correct response" do
        make_request

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when params are valid" do
      shared_examples "creates a game event and responds with success" do
        it do
          expect { make_request }.to change(UserGameEvent, :count).by(1)

          expect(response).to have_http_status(:ok)

          created_event = user.user_game_events.last

          expect(created_event).to have_attributes(
            game_id: game.id,
            occured_at: be_within(1.minute).of(DateTime.parse(occured_at)),
            game_event_type: UserGameEvent::EventTypes::COMPLETED
          )
        end
      end

      context "when occured_at is passed" do
        let(:occured_at) { "2012-12-12T00:00:00Z" }

        let(:params) do
          {
            game_event: {
              type: "COMPLETED",
              occured_at: occured_at,
              game_id: game.id
            }
          }
        end

        it_behaves_like "creates a game event and responds with success"
      end

      context "when occured_at is not passed" do
        let(:occured_at) { DateTime.current.iso8601 }

        let(:params) do
          {
            game_event: {
              type: "COMPLETED",
              game_id: game.id
            }
          }
        end

        it_behaves_like "creates a game event and responds with success"
      end
    end

    context "when params are NOT valid" do
      shared_examples "does not create game event" do
        it do
          make_request
          expect { make_request }.not_to change(UserGameEvent, :count)
          expect(response).to have_http_status(:forbidden)
        end
      end

      context "with malformed params" do
        let(:params) do
          {
            type: "COMPLETED",
            occured_at: "2012-12-12T00:00:00Z",
            game_id: game.id
          }
        end

        it_behaves_like "does not create game event"

        it "responds with error message" do
          make_request
          expect(JSON.parse(response.body)).to eq({
            "error"=>"Missing params", "message"=>"param is missing or the value is empty or invalid: game_event"
          })
        end
      end

      context "when type does not exist" do
        let(:params) do
          {
            game_event: {
              type: "STARTED",
              occured_at: "2012-12-12T00:00:00Z",
              game_id: game.id
            }
          }
        end

        it_behaves_like "does not create game event"

        it "responds with error message" do
          make_request
          expect(JSON.parse(response.body)).to eq({
            "error"=>"Game event creation failed, please fix the the following error and try again. Error: Validation failed: Game event type can't be blank, Game event type is not included in the list"
          })
        end
      end

      context "when occured_at is in the future" do
        let(:params) do
          {
            game_event: {
              type: "COMPLETED",
              occured_at: 1.year.from_now.iso8601,
              game_id: game.id
            }
          }
        end

        it_behaves_like "does not create game event"

        it "responds with error message" do
          make_request
          expect(JSON.parse(response.body)).to eq({
            "error"=>"Game event creation failed, please fix the the following error and try again. Error: Validation failed: Occured at can not be in future"
          })
        end
      end

      context "when game does not exist" do
        let(:params) do
          {
            game_event: {
              type: "COMPLETED",
              occured_at: "2012-12-12T00:00:00Z",
              game_id: "idonotexist"
            }
          }
        end

        it_behaves_like "does not create game event"

        it "responds with error message" do
          make_request
          expect(JSON.parse(response.body)).to eq({
            "error"=>"Game event creation failed, please fix the the following error and try again. Error: Validation failed: Game must exist, Game can't be blank"
          })
        end
      end
    end
  end
end
