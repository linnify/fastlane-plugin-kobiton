require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class KobitonHelper
      # class methods that you define here become available in your action
      # as `Helper::KobitonHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the kobiton plugin helper!")
      end
    end
  end
end
