#
# Be sure to run `pod lib lint TNChart4.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TNChart4'
  s.version          = '0.1.0'
  s.summary          = 'A short description of TNChart4.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Dmitriy Safarov/TNChart4'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Dmitriy Safarov' => 'kazdevelop@gmail.com' }
  s.source           = { :git => 'https://github.com/Dmitriy Safarov/TNChart4.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'TNChart4/Classes/**/*'
  
  # s.resource_bundles = {
  #   'TNChart4' => ['TNChart4/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Charts'
  s.dependency 'SnapKit'
  s.dependency 'Swinject'
  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'
  s.dependency 'Hero'

end
