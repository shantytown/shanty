module Shanty
  module Mixins
    module AttrCombinedAccessor
      # Creates an invariant accessor that allows getting and setting from the
      # same endpoint. It will operate in getter mode if you don't pass any
      # arguments when calling it, otherwise it will work in setter mode. Useful
      # when needing to chain methods (you can't chain standard attr_writer
      # methods because of the `= something` part) or when trying to create a
      # nice looking DSL.
      def attr_combined_accessor(*syms)
        syms.each do |sym|
          define_method(sym) do |*args|
            if args.empty?
              self.instance_variable_get(:"@#{sym}")
            else
              self.instance_variable_set(:"@#{sym}", *args)
            end
          end
        end
      end
    end
  end
end
