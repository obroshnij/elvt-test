RSpec.shared_context "with authenticated request" do
  let(:auth_headers) do
    session = user.sessions.create! # user should be defined in the test
    token = session.token

    {
      authorization: "Basic #{token}"
    }
  end
end
