require 'spec_helper'
require 'shanty/task_set'
require_fixture 'test_task_set'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(TaskSet) do
    after do
      TaskSet.instance_variable_set(:@partial_task, nil)
    end

    describe('.inherited') do
      let(:task_set) { Class.new(TestTaskSet) }

      it('adds the inheriting task set to the array of registered task sets') do
        TaskSet.inherited(task_set)

        expect(TaskSet.instance_variable_get(:@task_sets)).to include(task_set)
      end
    end

    describe('.task_sets') do
      it('returns the registered task sets') do
        expect(TaskSet.task_sets).to include(TestTaskSet)
      end
    end

    describe('.tasks') do
      it('returns the registered tasks') do
        expect(TestTaskSet.tasks).to include(:foo)
      end
    end

    describe('.partial_task') do
      it('returns a partial task') do
        expect(TestTaskSet.partial_task).to eql(klass: TestTaskSet, options: {}, params: {})
      end
    end

    describe('.desc') do
      it('sets the syntax field of the current partial task') do
        TaskSet.desc('foo', 'bar')

        expect(TaskSet.instance_variable_get(:@partial_task)).to include(syntax: 'foo')
      end

      it('sets the desc field of the current partial task') do
        TaskSet.desc('foo', 'bar')

        expect(TaskSet.instance_variable_get(:@partial_task)).to include(desc: 'bar')
      end
    end

    describe('.param') do
      it('sets the given param with the given options in the current partial task') do
        TaskSet.param('foo', bar: 'lux')

        expect(TaskSet.instance_variable_get(:@partial_task)[:params]).to include('foo' => { bar: 'lux' })
      end
    end

    describe('.option') do
      it('sets the given option with the given attrs in the current partial task') do
        TaskSet.option('foo', bar: 'lux')

        expect(TaskSet.instance_variable_get(:@partial_task)[:options]).to include('foo' => { bar: 'lux' })
      end
    end

    describe('.method_added') do
      it('adds the partial task to the list of tasks with the name of the method that was added') do
        TaskSet.method_added(:woowoo)

        expect(TaskSet.instance_variable_get(:@tasks)).to include(:woowoo)
      end

      it('resets the partial task') do
        TaskSet.method_added(:weewah)

        expect(TaskSet.instance_variable_get(:@partial_task)).to be_nil
      end
    end
  end
end
