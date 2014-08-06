# A mixin module enabling classes to have parents and children. It provides
# convenience methods for determining dependencies, depdenants, and a distance
# from the root node. Note that in contrast to a tree, this link graph module
# allows multiple parents.
module Shanty
module Graph
module Mixins
module ActsAsLinkGraphNode
  # The self.included idiom. This is described in great detail in a
  # fantastic blog post here:
  #
  # http://www.railstips.org/blog/archives/2009/05/15/include-vs-extend-in-ruby/
  #
  # Basically, this idiom allows us to add both instance *and* class methods
  # to the class that is mixing this module into itself without forcing them
  # to call extend and include for this mixin. You'll see this idiom everywhere
  # in the Ruby/Rails world, so we use it too.
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    attr_writer :parents, :children
  end

  # Public: The parents linked to this instance.
  #
  # Returns an Array of Objects.
  def parents
    @parents ||= []
  end

  # Public: The children linked to this instance.
  #
  # Returns an Array of Objects.
  def children
    @children ||= []
  end

  # Public: Add a node to the parents linked to this instance.
  #
  # node - The Object to add.
  def add_parent(node)
    parents << node
  end

  # Public: Add a node to the children linked to this instance.
  #
  # node - The Object to add.
  def add_child(node)
    children << node
  end

  # Public: Convenience method to return all of the children from this node in
  # the tree downwards to the leaves of the tree.
  #
  # Returns an Array of child Objects.
  def all_children
    children + children.map(&:all_children).flatten
  end

  # Public: Convenience method to return all of the parents from this node in
  # the tree upwards to the root of the tree.
  #
  # Returns an Array of parent Objects.
  def all_parents
    parents + parents.map(&:all_parents).flatten
  end

  # Public: Calculate the maximum number of traverses that need to be made to
  # reach the root from this node.
  #
  # Returns a Fixnum representing the traverses to the root. Note that a return
  # value of 0 means this is the root (ie. it has no parents).
  def distance_from_root
    return 0 if parents.empty?
    parents.map(&:distance_from_root).max + 1
  end
end
end
end
end
