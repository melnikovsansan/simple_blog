class Comment < ActiveRecord::Base

  attr_accessor :cached_children

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_votable

  belongs_to :commentable, :polymorphic => true

  # NOTE: Comments belong to a user
  belongs_to :user

  # Helper class method to lookup all comments assigned
  # to all commentable types for a given user.
  scope :find_comments_by_user, lambda { |user|
                                where(:user_id => user.id).order('created_at DESC')
                              }

  # Helper class method to look up all comments for
  # commentable class name and commentable id.
  scope :find_comments_for_commentable, lambda { |commentable_str, commentable_id|
                                        where(:commentable_type => commentable_str.to_s, :commentable_id => commentable_id).order('created_at DESC')
                                      }


  validates :body, :presence => true
  validates :user, :presence => true

  after_initialize { @cached_children ||= []}

  acts_as_nested_set :scope => [:commentable_id, :commentable_type]

  #helper method to check if a comment has children
  def has_children?
    children.any?
  end


  class << self

    # Helper class method to look up a commentable object
    # given the commentable class name and id
    def find_commentable(commentable_str, commentable_id)
      commentable_str.constantize.find(commentable_id)
    end

    # Helper class method that allows you to build a comment
    # by passing a commentable object, a user_id, and comment text
    # example in readme
    def build_from(obj, user_id, comment)
      new \
      :commentable => obj,
      :body        => comment,
      :user_id     => user_id
    end

    def create_and_bind(params, user_id)
      commentable = Comment.find_commentable params[:commentable_type], params[:commentable_id]
      comment = Comment.build_from commentable, user_id, params[:body]
      comment.save!
      comment.move_to_child_of Comment.find(params[:parent_id]) if params[:parent_id].present?
      comment
    end

    def build_tree(comments)
      comments.each do |comment|
        next if comment.root?
        comments.detect {|c| c.id.eql? comment.parent_id}.cached_children << comment
      end.reject(&:parent_id)
    end

  end
end
