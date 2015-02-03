require 'spec_helper'
require 'shanty/project_template'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(ProjectTemplate) do
    describe('.new') do
      it('does nothing if the Shantyfile does not exist')

      it('evals the Shantyfile within the project instance')
    end

    describe('#name') do
      it('defaults the name to the basename of the given path')
    end

    describe('#type') do
      it('defaults the type to StaticProject')
    end

    describe('#priority') do
      it('defaults the priority to 0')
    end

    describe('#plugins') do
      it('defaults the plugins to an empty array')
    end

    describe('#parents') do
      it('defaults the parents to an empty array')
    end

    describe('#options') do
      it('defaults the options to an empty array')
    end

    describe('#plugin') do
      it('adds the given plugin to the plugins array')
    end

    describe('#parent') do
      it('adds the given parent to the parents array')
    end

    describe('#option') do
      it('adds the given option to the parents hash')
    end

    describe('#env') do
      it('returns the env passed into the constructor')
    end

    describe('#path') do
      it('returns the path passed into the constructor')
    end

    describe('#after_create') do
      it('returns the value of after_create if no block is given')

      it('sets the value of after_create to the given block')
    end
  end
end
