# frozen_string_literal: true

# name: discourse-threefold-auth
# about: Enable login via Threefold connect
# version: 1.0.0
# authors: ThreeFold Dev
# url: https://github.com/Omarabdul3ziz/discourse-threefold-auth

require_relative "lib/omniauth_threefold"

enabled_site_setting :threefold_auth_enabled

register_svg_icon "fab-microsoft"

class ::ThreefoldAuthenticator < ::Auth::ManagedAuthenticator
  def name
    "threefold"
  end

  def register_middleware(omniauth)
    omniauth.provider :threefold,
                      setup: lambda { |env|
                        strategy = env["omniauth.strategy"]
                        strategy.options[:client_id] = SiteSetting.threefold_auth_client_id
                        strategy.options[
                          :client_secret
                        ] = SiteSetting.threefold_auth_client_secret
                      }
  end

  def enabled?
    SiteSetting.threefold_auth_enabled
  end

  def primary_email_verified?(auth_token)
    true
  end
end

auth_provider authenticator: ThreefoldAuthenticator.new, icon: "fab-microsoft"
