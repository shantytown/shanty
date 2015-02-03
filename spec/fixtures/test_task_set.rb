require 'shanty/task_set'

module Shanty
  # Test TaskSet fixture.
  class TestTaskSet < TaskSet
    desc 'foo --bonkers BONKERS [--cats] [--dogs DOGS]', 'test.foo.desc'
    option :bonkers, required: true, desc: 'test.options.bonkers'
    option :cats, type: :boolean, desc: 'test.options.cats'
    option :dogs, type: :string, desc: 'test.options.dogs'
    param :bar
    def foo(_options, bar)
      bar
    end
  end
end
