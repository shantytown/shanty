require 'shanty/task_set'

module Shanty
  # Test TaskSet fixture.
  class TestTaskSet < TaskSet
    desc 'foo [--cat CAT] [--dog] --catweasel CATWEASEL', 'test.foo.desc'
    option :cat, desc: 'test.options.cat'
    option :dog, type: :boolean, desc: 'test.options.dog'
    option :catweasel, required: true, type: :string, desc: 'test.options.catweasel'
    def foo(options)
      options
    end
  end
end
