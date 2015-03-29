module CommentsHelper
  def link_to_new_comment(text, object, **options)
    link_to text, new_comment_path(commentable_id: object.id, commentable_type: object.class.name, parent_id: options.delete(:parent_id) ), options
  end
end
