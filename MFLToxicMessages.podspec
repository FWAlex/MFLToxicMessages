Pod::Spec.new do |s|
  s.name             = 'MFLToxicMessages'
  s.version          = '0.1.0'
  s.summary          = 'The Toxic Messages feature of the MFL Recovery Apps'
 
  s.description      = <<-DESC
The Toxic Messages feature of the MFL Recovery Apps. This Allows the user to see a diagram of the toxic messages they might encounter.
                       DESC
 
  s.homepage         = 'https://github.com/FWAlex/MFLToxicMessages'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'FWAlex' => 'alex@futureworkshops.com' }
  s.source           = { :git => 'https://github.com/FWAlex/MFLToxicMessages.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '10.0'

  s.source_files = 'MFLToxicMessages/Classes/*.swift'

  # s.resource_bundles = {
  #   'MFLToxicMessages' => ['MFLToxicMessages/Classes/**/*.storyboard', 'MFLToxicMessages/Assets/*.xcassets', 'MFLToxicMessages/Classes/*.xib']
  # }
 
end