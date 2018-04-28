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
      expect(json_body).not_to be_empty

      # TODO: this test might return a false positive!
      expect(json_body.size).to eq(10)
    end

    # Note this test is separate from the JSON test - it is separate behavior
    it "returns a status code of 200" do
      # have_http_status is an RSpec helper available in controller, request and feature specs
      expect(response).to have_http_status(200)
    end

  end


  # Show route
  describe "GET /todos/:id" do
    # use our memoized var from earlier
    before {get("/todos/#{todo_id}")}

    # Context block!
    context "when the record exists" do
      it "returns the todo" do
        expect(json_body).not_to be_empty
        expect(json_body["id"]).to eq(todo_id)
      end

      it "returns a status code of 200" do
        expect(response).to have_http_status(200)
      end
    end


    context "when the record doesn't exist" do
      let(:todo_id) { 100 }

      it "returns a status code of 404" do
        expect(response).to have_http_status(404)
      end

      it "returns a not found message" do
        # Note use of regexp match here:
        expect(response.body).to match(/Couldn't find Todo/)
      end
    end
  end

  describe "POST /todos" do
    # Set "valid payload"
    let(:valid_attributes) { {title: "Learn MOAR TDD", created_by: "1"} }

    context "when the request is valid" do
      # Note "params" keyword
      before { post "/todos", params: valid_attributes}

      it "creates a todo" do
        expect(json_body["title"]).to eq("Learn MOAR TDD")
      end

      it "returns a status code of 201" do
        expect(response).to have_http_status(201)
      end
    end

    context "when the request is in invalid" do
      before { post "/todos", params: {title: "D'OH!"} }


      it "returns a status code of 422" do
        expect(response).to have_http_status(422)
      end

      it "returns an invalid message" do
        expect(response.body).to match(/Validation failed: Created by can't be blank/)
      end
    end
  end

  describe "PUT /todos/:id" do
    let(:valid_attributes) {{title: "Rock the Casbah"}}

    context "when the record exists" do
      before { put "/todos/#{todo_id}", params: valid_attributes }

      it "updates the record" do
        # We should test more than this!
        expect(response.body).to be_empty
      end

      it "returns a status code of 204" do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe "DELETE /todos/:id" do
    before { delete "/todos/#{todo_id}"}

    it "returns a status code of 204" do
      expect(response).to have_http_status(204)
    end
  end
end
