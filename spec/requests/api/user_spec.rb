require "rails_helper"

RSpec.describe "api/user" do
  let(:path) { "/api/user" }

  describe "POST" do
    subject(:make_request) { post path, params: params }

    context "when params are valid" do
      let(:params) do
        {
          email: "johndoe@gmail.com",
          password: "IAmUserWithPassword123!"
        }
      end

      it "creates a user" do
        expect { make_request }.to change(User, :count).by(1)

        expect(response).to have_http_status(:accepted)
      end
    end

    context "when params are NOT valid" do
      context "when password is missing" do
        let(:params) do
          {
            email: "johndoe@gmail.com",
            password: ""
          }
        end

        it "does not create a user" do
          expect { make_request }.not_to change(User, :count)

          expect(response).to have_http_status(:forbidden)
          expect(
            JSON.parse(
              response.body
            )
          ).to eq({
            "error" => "User creation failed, please fix the the following error and try again. Error: Validation failed: Password can't be blank, Password is too short (minimum is 8 characters)"
          })
        end
      end

      context "when password is not correct" do
        let(:params) do
          {
            email: "johndoe@gmail.com",
            password: "IamTooS"
          }
        end

        it "does not create a user" do
          expect { make_request }.not_to change(User, :count)

          expect(response).to have_http_status(:forbidden)
          expect(
            JSON.parse(
              response.body
            )
          ).to eq({
            "error" => "User creation failed, please fix the the following error and try again. Error: Validation failed: Password is too short (minimum is 8 characters), Password must include at least one uppercase letter, one digit, and one special character"
          })
        end
      end

      context "when email is taken" do
        let!(:user) { create(:user, email: "johndoe@gmail.com") }

        let(:params) do
          {
            email: "johndoe@gmail.com",
            password: "IamJustOkay123!"
          }
        end

        it "does not create a user" do
          expect { make_request }.not_to change(User, :count)

          expect(response).to have_http_status(:forbidden)
          expect(
            JSON.parse(
              response.body
            )
          ).to eq({
            "error" => "User creation failed, please fix the the following error and try again. Error: Validation failed: Email has already been taken"
          })
        end
      end
    end
  end
end
