class Comment < ApplicationRecord
  has_rich_text :content

  belongs_to :user
  belongs_to :story

  validates_presence_of :content
end
