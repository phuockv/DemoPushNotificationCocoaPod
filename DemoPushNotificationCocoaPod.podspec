#
# Be sure to run `pod lib lint DemoPushNotificationCocoaPod.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DemoPushNotificationCocoaPod'
  s.version          = '0.1.16'
  s.summary          = 'A short description of DemoPushNotificationCocoaPod.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'Use amazon service to push notificaiton and interact with native scrips code'
  s.homepage         = 'https://github.com/phuockv/DemoPushNotificationCocoaPod'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'phuockv' => 'phuoc.kieu@sutrixsolutions.com' }
  s.source           = { :git => 'https://github.com/phuockv/DemoPushNotificationCocoaPod.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

s.dependency 'AWSCore', '~> 2.7.0'
s.dependency 'AWSPinpoint', '~> 2.7.0'
s.dependency 'AWSAuthCore', '~> 2.7.0'
s.dependency 'AWSMobileClient', '~> 2.7.0'
s.dependency 'AWSCognitoIdentityProvider', '~> 2.7.0'
s.dependency 'AWSCognitoIdentityProviderASF','~> 1.0.1'
s.source_files = 'DemoPushNotificationCocoaPod/Classes/**/*{swift,json}'
s.platform     = :ios, '9.0'
s.swift_version = '4.0'

  # s.resource_bundles = {
  #   'DemoPushNotificationCocoaPod' => ['DemoPushNotificationCocoaPod/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
