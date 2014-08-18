require 'thor'

module Shanty
  # Public: An extension of the Thor class which strips our namespace
  # from implementing tasks. We still use the normal Thor runner so
  # any tasks which are loaded by other gems will be included with
  # their namespace intact. Any plugins can create tasks within the
  # Shanty namespace and expect to have it stripped when implmenting
  # this class.
  #
  # Credit for this method goes to lastobelus:
  # https://github.com/lastobelus/cleanthor
  class Task < Thor
    no_commands do
      def invoke(name = nil, *args)
        name.sub!(/^shanty:/, '') if name && $thor_runner
        super
      end
    end

    class << self
      def inherited(base) #:nodoc:
        base.send :extend, ClassMethods
      end
    end

    # Overridden Thor class methods
    module ClassMethods
      def namespace(name = nil)
        case name
        when nil
          constant = to_s.gsub(/^Thor::Sandbox::/, '')
          strip = $thor_runner ? /^Shanty::/ : /(?<=Shanty::)/
          constant = constant.gsub(strip, '')
          constant =  Thor::Util.snake_case(constant).squeeze(':')
          @namespace ||= constant
        else
          super
        end
      end
    end
  end
end
