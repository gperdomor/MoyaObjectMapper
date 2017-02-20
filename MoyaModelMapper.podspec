Pod::Spec.new do |s|
  s.name         = "MoyaModelMapper"
  s.version      = "1.0.0"
  s.summary      = "ModelMapper bindings for Moya"
  s.description  = <<-DESC
    [ModelMapper](https://github.com/lyft/mapper) bindings for
    [Moya](https://github.com/Moya/Moya) for easier JSON serialization.
    Includes [RxSwift](https://github.com/ReactiveX/RxSwift/) and [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa) bindings as well.
    Instructions on how to use it are in
    [the README](https://github.com/gperdomor/MoyaModelMapper).
  DESC
  s.homepage     = "https://github.com/gperdomor/MoyaModelMapper"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Gustavo Perdomo" => "gperdomor@gmail.com" }
  s.social_media_url   = ""
  
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.12"
  s.watchos.deployment_target = "3.1"
  s.tvos.deployment_target = "9.0"
  
  s.source       = { :git => "https://github.com/gperdomor/MoyaModelMapper.git", :tag => s.version.to_s }

  s.requires_arc = true
  s.default_subspec = "Core"

  s.subspec "Core" do |ss|
    ss.source_files  = "Sources/MoyaModelMapper/*.swift"
    ss.dependency "Moya", "~> 8.0.0"
    ss.dependency "ModelMapper"
    ss.framework  = "Foundation"
  end

  s.subspec "RxMoyaModelMapper" do |ss|
    ss.source_files = "Source/RxMoyaModelMapper/*.swift"
    ss.dependency "Moya/RxSwift", "~> 8.0.0"
    ss.dependency "MoyaModelMapper/Core"
    ss.dependency "RxSwift"
  end

  s.subspec "ReactiveMoyaModelMapper" do |ss|
    ss.source_files = "Sources/ReactiveMoyaModelMapper/*.swift"
    ss.dependency "Moya/ReactiveCocoa", "~> 8.0.0"
    ss.dependency "MoyaModelMapper/Core"
    ss.dependency "ReactiveSwift"
  end
end
