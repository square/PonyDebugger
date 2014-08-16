Pod::Spec.new do |s|
  s.name            =  'PonyDebugger'
  s.version         =  '0.4.0'
  s.summary         =  'Remote network and data debugging for your native iOS app using Chrome Developer Tools.'
  s.homepage        =  'https://github.com/square/PonyDebugger'
  s.description     =  'PonyDebugger is a remote debugging toolset. It is a client library and gateway server combination that uses Chrome Developer Tools on your browser to debug your application\s network traffic et managed object contexts'
  s.author          =  'Square'
  s.source          =  { :git => 'https://github.com/square/PonyDebugger.git'}
  s.license         =  'Apache License, Version 2.0'

  s.requires_arc = true
  s.ios.deployment_target = '5.0'
  s.source_files = 'ObjC/{DerivedSources,PonyDebugger}/**/*.{h,m}'
  s.frameworks = 'CoreData', 'CoreGraphics'
  s.dependency 'SocketRocket'
end
