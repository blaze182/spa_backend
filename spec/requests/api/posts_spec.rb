# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Posts", type: :request do
  describe "GET index" do
    before do
      create_list :post, 10
      get "/api/posts/"
    end

    it "returns HTTP 200" do
      expect(response).to be_success
    end

    it "sends a list of posts" do
      expect(json["data"].length).to eq 10
    end
  end

  describe "GET show" do
    let(:allowed_attributes) { %w(username title body).sort }
    let(:post_entry) { create :post, title: "Spec title" }

    before do
      get "/api/posts/#{post_entry.id}"
    end

    it "returns HTTP 200" do
      expect(response).to be_success
    end

    it "sends allowed attributes only" do
      expect(json["data"]["attributes"].keys.sort).to eq allowed_attributes
    end

    it "sends the same title" do
      expect(json["data"]["attributes"]["title"]).to eq "Spec title"
    end

    it "does not send private attributes" do
      expect(json["data"]["private_attr"]).to be_nil
    end
  end

  describe "POST create" do
    it "creates a new Post" do
      expect { post("/api/posts/", params: { post: { title: "TITLE" } }) }.
        to change { Post.count }.by 1
    end

    it "returns HTTP 200" do
      post("/api/posts/", params: { post: { title: "TITLE" } })
      expect(response).to be_success
    end

    it "returns HTTP 422 for invalid input" do
      post("/api/posts/", params: { post: { body: "BODY" } })
      expect(response.status).to eq(422)
    end
  end

  describe "PATCH update" do
    let(:post_entry) { create :post, title: "Spec title" }

    before do
      patch("/api/posts/#{post_entry.id}", params: { post: { title: "TITLE" } })
    end

    it "updates an existing Post" do
      expect(post_entry.reload.title).to eq "TITLE"
    end

    it "returns HTTP 200" do
      expect(response).to be_success
    end

    it "returns HTTP 422 for invalid input" do
      patch("/api/posts/#{post_entry.id}",
            params: { post: { username: "USER", title: nil } })
      expect(response.status).to eq(422)
    end
  end

  describe "DELETE destroy" do
    let(:post_entry) { create :post, title: "Spec title" }

    before do
      delete("/api/posts/#{post_entry.id}")
    end

    it "deletes an existing Post" do
      expect { post_entry.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "returns HTTP 200" do
      expect(response).to be_success
    end
  end
end
