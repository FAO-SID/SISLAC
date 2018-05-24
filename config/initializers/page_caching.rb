Rails.application.configure do
  config.action_controller.page_cache_directory = -> { Rails.root.join('public', request.domain) }
end
