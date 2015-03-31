module ForestBuilder

  # build collection of trees from current scope or gotten collection use instance's method :parent_id

  extend ActiveSupport::Concern

  included do

    attr_accessor :cached_children

    scope :build_forest, -> (collection = current_scope) do
      collection.each {|obj| obj.cached_children ||= []}
          .reject { |obj| collection.detect {|el| el.id.eql? obj.parent_id}.children << obj if obj.parent_id }
    end

  end

  def children
    cached_children || super
  end

end