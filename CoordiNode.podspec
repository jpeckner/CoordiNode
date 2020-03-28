Pod::Spec.new do |s|
  s.name = 'CoordiNode'
  s.version = '1.0.0'
  s.license = 'MIT'
  s.summary = "A lightweight Swift framework for predictably and safely managing your app's coordinator flow."
  s.homepage = 'https://github.com/jpeckner/CoordiNode'
  s.authors = { 'Justin Peckner' => 'pecknerj@gmail.com' }
  s.source = { :git => 'https://github.com/jpeckner/CoordiNode.git', :tag => '1.0.0' }

  s.ios.deployment_target = '11.0'

  s.source_files = 'CoordiNode/**/*.swift'

  s.swift_version = '5.0'
end