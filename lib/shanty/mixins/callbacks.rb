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
        cls.extend(ClassMethods)
      end

      # Common methods inherited by all classes
      module ClassMethods
        def class_callbacks
          @class_callbacks ||= Hash.new { |h, k| h[k] = [] }
        end

        def subscribe(*names, sym)
          names.each do |name|
            class_callbacks[name] << sym
          end
        end
      end

      def callbacks
        @callbacks ||= Hash.new { |h, k| h[k] = [] }
      end

      def subscribe(*names, sym)
        names.each do |name|
          callbacks[name] << sym
        end
      end

      def publish(name, *args)
        class_callback_methods = self.class.class_callbacks[name]
        callback_methods = callbacks[name]

        (class_callback_methods + callback_methods).each { |method| return false unless send(method, *args) }
        true
      end
    end
  end
end
