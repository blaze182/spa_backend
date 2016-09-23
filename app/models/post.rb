# frozen_string_literal: true
class Post < ApplicationRecord
  validates :title, :username, length: { maximum: 255 }
  validates :title, presence: true
end
