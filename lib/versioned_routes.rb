# frozen_string_literal: true

require 'versioned_routes/version'

require 'versioned_routes/route_version_info'
require 'versioned_routes/route_versions'

require 'action_dispatch'

ActionDispatch::Routing::RouteSet.prepend VersionedRoutes::RouteVersionInfo
ActionDispatch::Routing::Mapper.prepend VersionedRoutes::RouteVersions
