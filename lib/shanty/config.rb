module Shanty
  # Public: Config class for combining configurations from multiple sources
  class Config
    attr_reader :project_config, :env_config, :plugin_config

    def initialize(project_config, env_config, plugin_config)
      @project_config = project_config || {}
      @env_config = env_config || {}
      @plugin_config = plugin_config || {}
    end

    def [](key)
      project_config[key] || env_config[key] || plugin_config[key]
    end
  end
end
