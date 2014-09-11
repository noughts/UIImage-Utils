Pod::Spec.new do |s|
  s.name         = "UIImage+Utils"
  s.version      = "0.1.0"
  s.summary      = "UIImage+Utils"
  s.homepage     = "https://github.com/noughts/UIImage+Utils"
  s.author       = { "noughts" => "noughts@gmail.com" }
  s.source       = { :git => "https://github.com/noughts/UIImage+Utils.git" }
  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.platform = :ios
  s.requires_arc = true
  s.source_files = 'UIImage+Utils/**/*.{h,m}'
end
