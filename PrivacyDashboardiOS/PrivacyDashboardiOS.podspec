#
# Be sure to run `pod lib lint PrivacyDashboardiOS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PrivacyDashboardiOS'
  s.version          = '0.1.12'
  s.summary          = 'A short description of PrivacyDashboardiOS.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/decentralised-dataexchange/bb-consent-ios-privacy-dashboard.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Mumthasir mohammed' => 'mumthasir.mohammed@igrant.io' }
  s.source           = { :git => 'https://github.com/decentralised-dataexchange/bb-consent-ios-privacy-dashboard.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'

  s.source_files = '**/Classes/**/*.{h,m,swift,storyboard}'
# s.source_files = 'PrivacyDashboardiOS/*' 'PrivacyDashboardiOS/Classes/**/*', 'PrivacyDashboardiOS/Classes/*', 'PrivacyDashboardiOS/Resources/*'
#  s.resources = 'PrivacyDashboardiOS/**/*'

   s.resource_bundles = {
     'PrivacyDashboardiOS' => ['PrivacyDashboardiOS/Classes/PrivacyDashboard.storyboard','PrivacyDashboardiOS/Resources/PrivacyDashboard.xcassets']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Alamofire', '~> 5.4.1'
  s.dependency 'SwiftyJSON'
  s.dependency 'IQKeyboardManagerSwift'
  s.dependency "ExpandableLabel"
  s.dependency 'MiniLayout', '~> 1.3.0'
  s.dependency 'StepProgressView'
  s.dependency 'SDStateTableView'
  s.dependency 'SwiftEntryKit'
  s.dependency 'AFDateHelper'
  s.dependency 'Kingfisher'
end
