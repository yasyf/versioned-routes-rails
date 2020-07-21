# frozen_string_literal: true

require 'versioned_routes'
require 'spec_helper'

RSpec::Matchers.define :map_to_controller do |expected|
  get_controller = lambda do |actual|
    Rails.application.routes.recognize_path(actual.values.first, method: actual.keys.first)
    nil
  rescue ActionController::RoutingError => e
    e.message.match(/references missing controller: (.*)/)&.captures&.first
  end

  match do |actual|
    get_controller[actual] == expected
  end

  failure_message do |actual|
    "expected that '#{get_controller[actual]}' would be '#{expected}'"
  end
end

describe VersionedRoutes, type: :controller do
  before do
    Rails.application.routes.draw do
      scope :api, defaults: { format: :json } do
        version 1 do
          resources :messages do
            member do
              post :read
            end
          end
        end

        version 2 do
          resources :messages, only: [:show]
        end
      end
    end
  end

  it 'maps the routes to versioned controllers' do
    expect(get: '/api/v1/messages').to map_to_controller('V1::MessagesController')
    expect(post: '/api/v1/messages').to map_to_controller('V1::MessagesController')
    expect(post: '/api/v1/messages/1/read').to map_to_controller('V1::MessagesController')
    expect(get: '/api/v2/messages').to map_to_controller('V1::MessagesController')
    expect(get: '/api/v2/messages/1').to map_to_controller('V2::MessagesController')
    expect(post: '/api/v2/messages/1/read').to map_to_controller('V1::MessagesController')
  end
end
