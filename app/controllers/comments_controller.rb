class CommentsController < ApplicationController

  def new
    @comment = Comment.new params.permit(:commentable_id, :commentable_type)
  end

  def create
    comment_params = params.require(:comment)
    @commentable = comment_params[:commentable_type].constantize.find(comment_params[:commentable_id])
    @comment = Comment.build_from @commentable, current_user.id, comment_params[:body]
    @comment.save
  end

  def destroy

  end
end
