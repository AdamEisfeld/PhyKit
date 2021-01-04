Pod::Spec.new do |s|
  s.name             = 'PhysicsKit'
  s.version          = '2.0.0'
  s.summary          = 'Swift/Objc wrapper for Bullet Physics Engine with SceneKit support.'

  s.description      = <<-DESC
PhysicsKit wraps the popular Bullet physics library for Swift/Objc, providing additional functionality to attach
the physics simulation's output to a SceneKit scene's nodes.
                       DESC

  s.homepage         = 'https://github.com/AdamEisfeld/PhysicsKit'
  s.license          = { :type => 'zlib', :file => 'LICENSE' }
  s.author           = { 'AdamEisfeld' => 'adam.eisfeld@gmail.com' }
  s.source           = { :git => 'https://github.com/AdamEisfeld/PhysicsKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.osx.deployment_target = '11.1'

  s.vendored_frameworks = "Builds/2.0.0/PhysicsKit.xcframework"

end
