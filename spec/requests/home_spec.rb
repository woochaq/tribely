require 'rails_helper'

describe "HomeController", type: :request do
  it "renders the index template" do
    get root_path
    expect(response).to have_http_status(:ok)
  end
end
