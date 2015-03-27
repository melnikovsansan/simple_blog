class Post < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :published_at, :title, :content

  scope :published, -> { where 'posts.published_at < date(\'now\')' }
end
