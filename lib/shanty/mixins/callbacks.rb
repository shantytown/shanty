require 'hooks'

module Shanty
  module Mixins
    # A mixin to implement publish/subscribe style callbacks in the class that
    # includes this.
    module Callbacks
      # The self.included idiom. This is described in great detail in a
      # fantastic blog post here:
      #
      # http://www.railstips.org/blog/archives/2009/05/15/include-vs-extend-in-ruby/
      #
      # Basically, this idiom allows us to add both instance *and* class methods
      # to the class that is mixing this module into itself without forcing them
      # to call extend and include for this mixin. You'll see this idiom everywhere
      # in the Ruby/Rails world, so we use it too.
      def self.included(cls)
        cls.include(Hooks)
        cls.extend(ClassMethods)
      end

      # Common methods inherited by all classes
      module ClassMethods
        def subscribe(*names, sym)
          names.each do |name|
            define_hook(name, halts_on_falsey: true) unless respond_to?(name)
            send(name, sym)
          end
        end
      end

      def publish(name, *args)
        return true if self.class.callbacks_for_hook(name).nil?
        results = run_hook(name, *args)
        !results.halted?
      end
    end
  end
end
