require 'spec_helper'
require 'shanty/project'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(Project) do
    describe('.new') do
      it('stores the name from the project template')

      it('stores the path from the project template')

      it('stores the options from the project template')

      it('stores the parents from the project template')
    end

    describe('#name') do
      it('returns the name from the project template in the constructor')
    end

    describe('#path') do
      it('returns the path from the project template in the constructor')
    end

    describe('#options') do
      it('returns the options from the project template in the constructor')
    end

    describe('#parents_by_path') do
      it('returns the parents from the project template in the constructor')
    end

    describe('#options') do
      it('returns the options from the project template in the constructor')
    end
  end
end
