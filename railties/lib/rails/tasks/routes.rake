desc 'Print out all defined routes in match order, with names. Target specific controller with CONTROLLER=x.'
task routes: :environment do
  all_routes = Rails.application.routes.routes
  require 'action_dispatch/routing/inspector'
  if (controller = ENV['CONTROLLER'])
    ActiveSupport::Deprecation.warn "Using `CONTROLLER=#{controller} rake routes` is deprecated and no longer works. Consider using `rake routes | grep #{controller}` instead."
  end
  inspector = ActionDispatch::Routing::RoutesInspector.new(all_routes)
  puts inspector.format(ActionDispatch::Routing::ConsoleFormatter.new)
end
