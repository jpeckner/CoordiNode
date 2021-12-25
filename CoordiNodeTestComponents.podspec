Pod::Spec.new do |s|
  s.name = 'CoordiNodeTestComponents'
  s.version = '1.0.3'
  s.summary = 'Test components for CoordiNode framework.'
  s.homepage = 'https://github.com/jpeckner/CoordiNode'
  s.authors = { 'Justin Peckner' => 'pecknerj@gmail.com' }
  s.license = 'MIT'
  s.source = { 
    :git => 'https://github.com/jpeckner/CoordiNode.git', 
    :tag => 'v' + s.version.to_s 
  }

  s.ios.deployment_target = '11.0'
  s.source_files = 'CoordiNodeTestComponents/**/*.swift'
  s.swift_version = '5.0'
  s.dependency 'CoordiNode', '' + s.version.to_s
end
