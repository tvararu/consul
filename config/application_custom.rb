module Consul
  class Application < Rails::Application
    config.i18n.default_locale = :en
    config.deploy = config_for(:deploy)
    config.action_view.cache_template_loading = false
  end
end
