Pod::Spec.new do |s|

  s.name                = "Weakable"
  s.version             = "1.0.0"
  s.summary             = "An easy way to hold weak references in Swift."
  s.screenshot          = "https://github.com/BellAppLab/Weakable/raw/master/Images/weakable.png"

  s.description         = <<-DESC
Weakable is an easy way to hold `weak` references in Swift.

With Weakable you can create weak arrays, weak dictionaries and many other cool things.

😎
                   DESC

  s.homepage            = "https://github.com/BellAppLab/Weakable"

  s.license             = { :type => "MIT", :file => "LICENSE" }

  s.author              = { "Bell App Lab" => "apps@bellapplab.com" }
  s.social_media_url    = "https://twitter.com/BellAppLab"

  s.ios.deployment_target     = "9.0"
  s.watchos.deployment_target = "3.0"
  s.osx.deployment_target     = "10.10"
  s.tvos.deployment_target    = "9.0"

  s.module_name         = 'Weakable'

  s.source              = { :git => "https://github.com/BellAppLab/Weakable.git", :tag => "#{s.version}" }

  s.source_files        = "Sources/Weakable"

  s.framework           = "Foundation"

end
