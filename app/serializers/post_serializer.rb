# frozen_string_literal: true
class PostSerializer < ActiveModel::Serializer
  attributes :id, :username, :title, :body
end
