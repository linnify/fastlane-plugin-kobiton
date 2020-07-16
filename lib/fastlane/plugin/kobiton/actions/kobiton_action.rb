require 'fastlane/action'
require_relative '../helper/kobiton_helper'

module Fastlane
  module Actions
    class KobitonAction < Action
      def self.run(params)
        require "base64"

        username = params[:username]
        api_key = params[:api_key]

        base64Authorization = Base64.encode64("#{username}:#{api_token}")
        authorization = "Basic #{base64authorization}"

        filepath = params[:file]
        app_id = params[:app_id]

        filename = File.basename(filepath)

        UI.message("Getting S3 upload URL...")

        kobiton_upload_pair = self.get_s3_upload_url(filename, app_id, authorization)

        UI.message("Got S3 upload URL.")

        app_path = kobiton_upload_pair["appPath"]
        upload_url = kobiton_upload_pair["url"]

        UI.message("Uploadfing the build to Amazon S3 storage...")

        upload_success = self.upload_to_s3(upload_url, filepath)

        if upload_success
          UI.message("Successfully uploaded the build to Amazon S3 storage.")
        else
          UI.user_error!("Failed to upload the build to Amazon S3 storage.")
        end

        self.notify_kobiton_after_file_upload(app_path, filename, authorization)

        UI.message("Successfully uploaded the build to Kobiton!")

      end

      def self.description
        "Upload build to Kobiton"
      end

      def self.authors
        ["Vlad Rusu"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "A Fastlane plugin which allows you to upload the iOS and Android builds to Kobiton"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :api_key,
            env_name: "FL_KOBITON_API_KEY",
            description: "API key from Kobiton.",
            verify_block: proc do |value|
              UI.user_error!("No API key for KobitonUpload given, pass using `api_key: 'token'`") unless (value and not value.empty?)
            end,
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :username,
            env_name: "FL_KOBITON_USERNAME",
            description: "The username or email of your Kobiton account",
            verify_block: proc do |value|
              UI.user_error!("No username/email for KobitonUpload given, pass using `username: 'username/email'`") unless (value and not value.empty?)
            end,
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :file,
            env_name: "FL_KOBITON_FILE",
            description: "The build file to upload to Kobiton",
            verify_block: proc do |value|
              UI.user_error!("No build file for KobitonUpload given, pass using `file: 'file_path'`") unless (value and not value.empty?)
            end,
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :app_id,
            env_name: "FL_KOBITON_APP_ID",
            description: "The Kobiton app ID of the application",
            verify_block: proc do |value|
              UI.user_error!("No app ID or value 0 for KobitonUpload given, pass using `app_id: <app_id>`") unless (value and value != 0)
            end,
            optional: false,
            type: Integer
          )
        ]
      end

      def self.is_supported?(platform)
        [:ios, :android].include?(platform)
      end

      def self.get_s3_upload_url(filename, app_id, authorization)
        require "rest-client"
        require "json"

        headers = {
          "Authorization": authorization,
          "Content-Type": "application/json",
          "Accept": "application/json"
        }

        response = RestClient.post "https://api.kobiton.com/v1/apps/uploadUrl", {
          "filename" => filename,
          "appId" => app_id
        }, headers

        return JSON.parse(response)
      end

      def self.upload_to_s3(url, filepath)
        require "rest-client"

        headers = {
          "Content-Type": "application/octet-stream",
          "x-amz-tagging": "unsaved=true"
        }

        response = RestClient.put url, File.read(filepath), headers

        return response.code == 200
      end

      def self.notify_kobiton_after_file_upload(app_path, filename, authorization)
        require "rest-client"

        headers = {
          "Authorization" => authorization,
          "Content-Type" => "application/json"
        }

        response = RestClient.poste "https://api.kobiton.com/v1/apps", {
          "filename": filename,
          "appPath": app_path
        }, headers
      end
    end
  end
end
