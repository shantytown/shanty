require 'uri'
require 'pathname'

module Shanty
  # Public: Contain information on an artifact published by a project
  class Artifact
    attr_reader :file_extension, :plugin, :uri

    # Public: Initialise an artifact instance.
    #
    # file_extension - The extension of the artifact.
    # plugin - The plugin publishing the artifact.
    # uri - The URI to the object.
    #
    # Fails if the URI is not absolute or a scheme is missing.
    def initialize(file_extension, plugin, uri)
      @file_extension = file_extension
      @plugin = plugin
      @uri = uri

      validate_uri
    end

    # Public: Whether the underlying URI of the artifact points to a local
    # file path.
    #
    # Returns a Boolean representing whether the artifact is local.
    def local?
      @uri.scheme == 'file'
    end

    # Public: If the underlying artifact is stored locally, returns the path
    # at which the artifact can be found.
    #
    # Returns a String representing the path at which the artifact can be found.
    # Raises RuntimeError if the artifact is not local.
    def to_local_path
      return @uri.path if local?
      raise 'URI is not a local resource'
    end

    # Public: A simple string representation of this artifact.
    #
    # Returns a String representing the URI at which this artifact can be found.
    def to_s
      @uri.to_s
    end

    private

    def validate_uri
      raise 'Scheme not present on URI' unless @uri.absolute?
      raise 'URI is not absolute' if @uri.path.nil?
    end
  end
end
