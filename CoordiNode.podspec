Pod::Spec.new do |s|
  s.name = 'CoordiNode'
  s.version = '1.1.0'
  s.summary = "A lightweight Swift framework for predictably and safely managing your app's coordinator flow."
  s.homepage = 'https://github.com/jpeckner/CoordiNode'
  s.authors = { 'Justin Peckner' => 'pecknerj@gmail.com' }
  s.license = 'MIT'
  s.source = { 
    :git => 'https://github.com/jpeckner/CoordiNode.git', 
    :tag => 'v' + s.version.to_s 
  }

  s.ios.deployment_target = '11.0'
  s.source_files = 'CoordiNode/**/*.swift'
  s.swift_version = '5.0'
  s.resources = ['CoordiNode/Resources/CoordiNodeGenerator']
end
