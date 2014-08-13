module Shanty
  module Mixins
    # Public: mixin which allows a class to implement callbacks around methods
    module Callbacks
      def self.included(cls)
        cls.extend(ClassMethods)
      end

      # Common methods inherited by implementing classes
      module ClassMethods
        class << self
          attr_accessor :before_callbacks, :after_callbacks, :around_callbacks
        end

        def before(sym)
          @before_callbacks ||= []
          @before_callbacks << sym
        end

        def after(sym)
          @after_callbacks ||= []
          @after_callbacks << sym
        end

        def around(sym)
          @around_callbacks ||= []
          @around_callbacks << sym
        end
      end

      def with_callbacks(_name)
        # before
        # around

        self.class.after_callbacks.reduce(yield) do |acc, sym|
          send(sym, acc)
        end

        # after
      end
    end
  end
end
