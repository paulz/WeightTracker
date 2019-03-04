platform :ios, '12.0'

def bdd
  pod 'Quick'
  pod 'Nimble'
end

target 'WeightTracker' do
  use_frameworks!
  pod 'SwinjectStoryboard'
  pod 'SwinjectAutoregistration'

  target 'AppSpecs' do
    inherit! :search_paths
    bdd
  end
end

target 'UITests' do
  bdd
end
