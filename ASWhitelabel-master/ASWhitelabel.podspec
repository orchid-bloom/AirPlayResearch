Pod::Spec.new do |s|
  s.name             = "ASWhitelabel"
  s.version          = "0.5.0"
  s.summary          = "Implement a whitelabel version of AirService in your app"
  s.homepage         = "http://www.airservice.com"
  s.license          = 'MIT'
  s.author           = { "danielbowden" => "github@bowden.in" }
  s.source           = { :git => "git@github.com:airservice/ASWhitelabel.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  s.requires_arc = true

  s.source_files = 'Classes'

  s.public_header_files = 'Classes/*.h'
end
