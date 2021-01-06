automaticVersion = '1.0.0'
Pod::Spec.new do |s|
  s.name             = 'PhyKit'
  s.version          = automaticVersion
  s.summary          = 'Swift/Objc wrapper for Bullet Physics Engine with SceneKit support.'

  s.description      = <<-DESC
PhyKit wraps the popular Bullet physics library for Swift/Objc, providing additional functionality to attach
the physics simulation's output to a SceneKit scene's nodes.
                       DESC

  s.homepage         = 'https://github.com/AdamEisfeld/BulletKit'
  s.license          = { :type => 'zlib', :file => 'LICENSE' }
  s.author           = { 'AdamEisfeld' => 'adam.eisfeld@gmail.com' }
  s.source           = { :git => 'https://github.com/AdamEisfeld/BulletKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.osx.deployment_target = '11.0'

  s.vendored_frameworks = "Framework/PhyKit.xcframework"

end
