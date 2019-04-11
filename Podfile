platform :ios, '12.0'
use_frameworks!

def bdd
  pod 'Quick'
  pod 'Nimble'
end

target 'WeightTracker' do
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
