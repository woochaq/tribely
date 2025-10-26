class Comment < ApplicationRecord
  include ActionView::RecordIdentifier

  has_rich_text :content

  belongs_to :user
  belongs_to :story

  validates_presence_of :content

  after_create_commit :broadcast_create
  after_update_commit :broadcast_update
  after_destroy_commit :broadcast_destroy

  private

  def broadcast_create
    broadcast_prepend_later_to(
      story.board.project,
      target: dom_id(story, "comments"),
      renderable: Components::Comments::Comment, locals: { comment: self }
    )
  end

  def broadcast_update
    broadcast_replace_later_to(
      story.board.project,
      target: self,
      renderable: Components::Comments::Comment, locals: { comment: self }
    )
  end

  def broadcast_destroy
    broadcast_remove_to story.board.project, target: self
  end
end
