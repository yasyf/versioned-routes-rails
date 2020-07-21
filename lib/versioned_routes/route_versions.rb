# frozen_string_literal: true

module VersionedRoutes
  module RouteVersions
    def version(number, &block)
      @set.current_version_number = number
      @set.current_version.block = block

      versions = @set
                 .version_info
                 .values
                 .select { |info| info.number <= number }
                 .sort_by(&:number)
                 .reverse

      scope path: "v#{number}", as: "v#{number}" do
        versions.each do |info|
          scope module: "v#{info.number}", defaults: { api_version: info.number } do
            info.block.call if info.number <= number
          end
        end
      end

      @set.current_version_number = nil
    end
  end
end
