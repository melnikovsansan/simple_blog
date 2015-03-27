module CommentsHelper
  def id_comments_container(object)
    "#{object.class.name.tableize}_#{object.id}_comments"
  end

  def link_to_new_comment(text, object, **options)
    link_to text, new_comment_path(commentable_id: object.id, commentable_type: object.class.name), options
  end
end
