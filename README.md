# kobiton plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-kobiton)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-kobiton`, add it to your project by running:

Add the following line to your Pluginfile:

```ruby
gem "fastlane-plugin-kobiton", git: "https://github.com/linnify/fastlane-plugin-kobiton.git"
```

Then run the following commands:

```bash
bundle install
bundle exec fastlane install_plugins
```

Then you will need to use `bundle exec` afterwards because this repo is cached by the bundler:

```bash
bundle exec fastlane action kobiton
```

for printing the documentation of this action

```bash
bundle exec fastlane dev
```

for running the `dev` lane which might contain the `kobiton` action.

## About kobiton

Upload build to Kobiton

This is a lightweight Fastlane plugin which uploads a given build to Kobiton platform. This action won't trigger any tests on Kobiton. For an automated triggering of tests on Kobiton, please integrate using Jenkins.

This action does not have any output parameters yet, we are planning to define some in a future version.

## Example

Basic usage:

```ruby
platform :ios do
  desc "A simple example of an iOS dev lane"
  lane :dev do
    increment_build_number
    gym(
      workspace: "MyAwesomeApp.xcworkspace",
      clean: true,
    )
    kobiton(
      api_key: "01234567-89AB-CDEF-0123-456789AB",
      username: "johndoe",
      file: lane_context[SharedValues::IPA_OUTPUT_PATH],
      app_id: 38007
    )
  end
end
```

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
