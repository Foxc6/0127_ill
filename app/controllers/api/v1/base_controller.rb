require 'api_responder'
require 'json_body_handler'
require 'gatekeeper'
require 'header_extractor'

module Api
  module V1
    class BaseController < ApplicationController
      self.responder = ApiResponder

      attr_reader :current_account
      #serialization_scope :current_account

      include JsonBodyHandler

      # rescue_from ActionController::ParameterMissing do |exception|
      #   head 400
      # end

      # skip_before_action

      before_filter :verify_authenticity_token

      before_filter :log_request_information
      before_filter :authenticate_application!
      before_filter :white_list_locale

      # before_action :ensure_account_username!
      # before_action :find_or_create_account!
      # before_action :ensure_account_authentication_token!

      #handle_json_body
      respond_to :json

      protected

      def log_request_information
        Rails.logger.info('== Start Request Information ==')
        Rails.logger.info("   Accept: #{HeaderExtractor.new('Accept', env).value}")
        Rails.logger.info("   X-Application-Authentication-Token: #{HeaderExtractor.new('X-Application-Authentication-Token', env).value}")
        Rails.logger.info("   X-Locale: #{HeaderExtractor.new('X-Locale', env).value}")
        Rails.logger.info("   X-Device-Identifier: #{HeaderExtractor.new('X-Device-Identifier', env).value}")
        Rails.logger.info("   X-Account-Authentication-Token: #{HeaderExtractor.new('X-Account-Authentication-Token', env).value}")
        Rails.logger.info("   X-Account-Username: #{HeaderExtractor.new('X-Account-Username', env).value}")
        Rails.logger.info("   X-Latitude: #{HeaderExtractor.new('X-Latitude', env).value}")
        Rails.logger.info("   X-Longitude: #{HeaderExtractor.new('X-Longitude', env).value}")
        Rails.logger.info('== End Request Information ====')
      end

      def authenticate_application!
        head :unauthorized unless Gatekeeper.application_authenticated?(HeaderExtractor.new('X-Application-Authentication-Token', env).value)
      end

      def ensure_account_username!
        head :unauthorized unless HeaderExtractor.new('X-Account-Username', env).value.present?
      end

      def find_or_create_account!
        @current_account ||= Account.find_or_create_by_username(HeaderExtractor.new('X-Account-Username', env).value)
      end

      def ensure_account_authentication_token!
        head :unauthorized unless HeaderExtractor.new('X-Account-Authentication-Token', env).value.present?
      end

      def verify_account_authentication_token!
        true
      end

      def latitude
        @latitude ||= HeaderExtractor.new('X-Latitude', env).value
      end

      def longitude
        @longitude ||= HeaderExtractor.new('X-Longitude', env).value
      end

      def coordinates
        @coordinates ||= [latitude, longitude]
      end

      def ensure_coordinates!
        @coordinates = configatron.default_coordinates unless latitude.present? && longitude.present?
      end

      def device_identifier
        @device_identifier ||= HeaderExtractor.new('X-Device-Identifier', env).value
      end

      def white_list_locale
        @locale_header = HeaderExtractor.new('X-Locale', env).value
        if(locales.include?(@locale_header))
          @locale = @locale_header
          I18n.locale = @locale.to_sym
        elsif @locale_header.blank?
          @locale = default_locale

          # I18n.locale = @locale.to_sym
        else
          @locale = default_locale
        end

        @locale_data = Locale.where(code:@locale_header).first

        Rails.logger.info("LOCALE CODE: #{@locale_header}")

      end
    end
  end
end
