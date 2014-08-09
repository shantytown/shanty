module Shanty
  module Mixins
    module Callbacks
      def self.included(cls)
        cls.extend(ClassMethods)
      end

      module ClassMethods
        @@before_callbacks = []
        @@after_callbacks = []
        @@around_callbacks = []

        def before(sym)
          @@before_callbacks << sym
        end

        def after
          @@after_callbacks << sym
        end

        def around
          @@around_callbacks << sym
        end
      end

      def with_callbacks(name)
        # before
        # around

        @@around_callbacks.inject(yield) do |acc, sym|
          send(sym, acc)
        end

        # after
      end
    end
  end
end
