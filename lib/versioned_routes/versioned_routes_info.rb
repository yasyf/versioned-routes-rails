# frozen_string_literal: true

module VersionedRoutes
  class VersionedRoutesInfo
    attr_accessor :number, :block, :paths

    def initialize(number)
      @number = number
      @block = nil
      @paths = Hash.new { |h, k| h[k] = Set.new }
    end

    def append(mapping)
      verb = mapping.make_route(nil, nil).verb
      regex = mapping.path.to_regexp
      return false if paths[verb].include? regex
      paths[verb] << regex
      true
    end
  end
end
