class CommentsController < ApplicationController

  def new
    authorize! :create, Comment
    @comment = Comment.new params.permit(:commentable_id, :commentable_type, :parent_id)
  end

  def create
    authorize! :create, Comment
    comment_params = params.require(:comment)
    @commentable = Comment.find_commentable comment_params[:commentable_type], comment_params[:commentable_id]
    @comment = Comment.build_from @commentable, current_user.id, comment_params[:body]
    @comment.save!
    @comment.move_to_child_of Comment.find(comment_params[:parent_id]) if comment_params[:parent_id].present?
  rescue Exception => e
    render js: "alert('#{e.message}')"
  end

  def destroy
    @comment = Comment.find(params[:id])
    authorize! :destroy, @comment
    @comment.destroy!
  rescue Exception => e
    render js: "alert('#{e.message}')"
  end
end
