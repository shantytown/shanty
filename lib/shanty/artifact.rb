require 'uri'
require 'pathname'

module Shanty
  # Public: Contain information on an artifact published by a project
  class Artifact
    attr_reader :file_extension, :plugin, :uri

    # Public: Initialise an artifact instance
    #
    # file_extension - The extension of the artifact
    # plugin         - The plugin publishing the artifact
    # uri            - The URI to the object
    #
    # Fails if the URI is not absolute or
    # the mime type is not valid
    def initialize(file_extension, plugin, uri)
      @file_extension = file_extension
      @plugin = plugin
      @uri = uri
      validate_uri
    end

    def local?
      @uri.scheme == 'file'
    end

    def to_local_path
      return @uri.path if local?
      fail 'URI is not a local resource'
    end

    def to_s
      @uri.to_s
    end

    private

    def validate_uri
      fail 'Scheme not present on URI' unless @uri.absolute?
      fail 'URI is not absolute' if @uri.path.nil?
    end
  end
end
