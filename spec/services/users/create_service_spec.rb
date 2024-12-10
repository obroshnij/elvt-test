require "rails_helper"

module Users
  RSpec.describe CreateService do
    describe ".call" do
      subject(:call) { described_class.call(**params) }

      context "when params are valid" do
        let(:params) do
          {
            email: "john.snow@gmail.com",
            password: "JohnyDragon2024!"
          }
        end

        it "creates user in db" do
          expect { call }.to change(User, :count).by(1)

          expect(User.last.email).to eq("john.snow@gmail.com")
        end
      end

      context "when email was already taken" do
        let!(:user) { create(:user, email: "john.snow@gmail.com") }

        let(:params) do
          {
            email: "john.snow@gmail.com",
            password: "JohnyDragon2024!"
          }
        end

        it "raises an error" do
          expect { call }.to raise_error(Users::Errors::UserDataIsNotValidError, "Validation failed: Email has already been taken")
        end
      end

      context "when email is ivalid" do
        let(:params) do
          {
            email: "john.snow",
            password: "JohnyDragon2024!"
          }
        end

        it "raises an error" do
          expect { call }.to raise_error(Users::Errors::UserDataIsNotValidError, "Validation failed: Email is invalid")
        end
      end

      context "when password is invalid" do
        let(:params) do
          {
            email: "john.snow@gmail.com",
            password: "jd"
          }
        end

        it "raises an error" do
          expect { call }.to raise_error(Users::Errors::UserDataIsNotValidError, "Validation failed: Password is too short (minimum is 8 characters), Password must include at least one uppercase letter, one digit, and one special character")
        end
      end
    end
  end
end
