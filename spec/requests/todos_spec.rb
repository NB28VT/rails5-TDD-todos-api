require "rails_helper"
# Code relies on custom JSON helper we will define in spec helper

RSpec.describe "Todos API", type: :request do
  # Initialize test data
  # Let stores memoized (cached for quick lookup) helper.
  # let! invocated before each example
  # let without bang is lazy evaluated
  let!(:todos) {create_list(:todo, 10)}
  let(:todo_id) {todos.first.id}


  # Request spec for GET /todos

  describe "GET /todos" do
    # Here, "before" means hit this route before each example in this describe block
    before {get "/todos"}

    it "returns todos" do
      # JSON is a custom helper we will add to spec helper
      expect(json).not_to be_empty

      # TODO: this test might return a false positive!
      expect(json.size).to eq(10)
    end

    # Note this test is separate from the JSON test - it is separate behavior
    it "returns a status code of 200" do
      # have_http_status is an RSpec helper available in controller, request and feature specs
      expect(response).to have_http_status(200)
    end

  end







end
