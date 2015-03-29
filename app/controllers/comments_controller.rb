class CommentsController < ApplicationController
  load_and_authorize_resource only: :destroy

  def new
    authorize! :create, Comment
    @comment = Comment.new params.permit(:commentable_id, :commentable_type, :parent_id)
  end

  def create
    authorize! :create, Comment
    @comment = Comment.create_and_bind params.require(:comment), current_user.id
  rescue Exception => e
    render_alert e
  end

  def destroy
    @comment.destroy!
  rescue Exception => e
    render_alert e
  end
end
