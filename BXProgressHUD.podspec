#
# Be sure to run `pod lib lint BXProgressHUD.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "BXProgressHUD"
  s.version          = "1.7.1"
  s.summary          = "BXProgressHUD A ProgressHUD based on MBProgressHUD writtern with Swift 2.1 with some new feature"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
                BXProgressHUD A ProgressHUD based on MBProgressHUD,
                As this is rewritten with Swift 2.1,It should be used more naturely in Swift Code,
                And It's add some Builder Pattern Support.
                       DESC

  s.homepage         = "https://github.com/banxi1988/BXProgressHUD"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "banxi1988" => "banxi1988@gmail.com" }
  s.source           = { :git => "https://github.com/banxi1988/BXProgressHUD.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/banxi1988'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit' #, 'MapKit'
  s.dependency 'PinAuto'
  # s.dependency 'AFNetworking', '~> 2.3'
end
