# frozen_string_literal: true

require 'versioned_routes/versioned_routes_info'

module VersionedRoutes
  module RouteVersionInfo
    attr_accessor :current_version_number

    def clear!
      reset_version_info!
      super
    end

    def add_route(mapping, name)
      return unless current_version.append mapping
      super
    end

    def current_version
      version_info[current_version_number || 1]
    end

    def version_info
      @version_info || reset_version_info!
    end

    private

    def reset_version_info!
      @version_info = Hash.new { |h, k| h[k] = VersionedRoutesInfo.new(k) }
    end
  end
end
