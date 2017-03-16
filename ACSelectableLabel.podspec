#
# Be sure to run `pod lib lint ACSelectableLabel.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ACSelectableLabel'
  s.version          = '1.0.2'
  s.summary          = 'A subclass on UILabel that provides a copy and link to others apps\'schemes'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A subclass on UILabel that provides a UIMenuController with :
- current features
- copy and link to others apps\'schemes
                       DESC

  s.homepage         = 'https://github.com/antoine20001/ACSelectableLabel'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'antoine.cointepas@orange.fr' => 'antoine.cointepas@orange.fr' }
  s.source           = { :git => 'https://github.com/antoine20001/ACSelectableLabel.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/antoine20001'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ACSelectableLabel/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ACSelectableLabel' => ['ACSelectableLabel/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
