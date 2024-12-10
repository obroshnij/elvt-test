require "rails_helper"

RSpec.describe "api/sessions" do
  let(:path) { "/api/sessions" }

  describe "POST" do
    let!(:user) { create(:user, email: "tttest@example.com", password: "IamPassword2021@") }

    subject(:make_request) { post path, params: params }

    context "when params are valid" do
      let(:params) do
        {
          email: "tttest@example.com",
          password: "IamPassword2021@"
        }
      end

      it "authenticates a user" do
        expect { make_request }.to change(Session, :count).by(1)

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq({ "token" => user.sessions.last.token })
      end
    end

    context "when params are NOT valid" do
      context "when password is missing" do
        let(:params) do
          {
            email: "tttest@example.com",
            password: ""
          }
        end

        it "does not authenticate a user" do
          expect { make_request }.not_to change(Session, :count)

          expect(response).to have_http_status(:unauthorized)
          expect(JSON.parse(response.body)).to eq({
            "error" => "Authentication Failed. Email or Password is incorrect"
          })
        end
      end

      context "when password is not correct" do
        let(:params) do
          {
            email: "tttest@example.com",
            password: "IamTooS"
          }
        end

        it "does not authenticate a user" do
          expect { make_request }.not_to change(Session, :count)

          expect(response).to have_http_status(:unauthorized)
          expect(JSON.parse(response.body)).to eq({
            "error" => "Authentication Failed. Email or Password is incorrect"
          })
        end
      end

      context "when email is not correct" do
        let(:params) do
          {
            email: "tttest@example.com1",
            password: "IamPassword2021@"
          }
        end

        it "does not authenticate a user" do
          expect { make_request }.not_to change(Session, :count)

          expect(response).to have_http_status(:unauthorized)
          expect(JSON.parse(response.body)).to eq({
            "error" => "Authentication Failed. Email or Password is incorrect"
          })
        end
      end
    end
  end
end
