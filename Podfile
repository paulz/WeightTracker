platform :ios, '12.0'

def bdd
  pod 'Quick'
  pod 'Nimble'
end

target 'WeightTracker' do
  use_frameworks!

  target 'AppSpecs' do
    inherit! :search_paths
    bdd
  end
end

target 'UITests' do
  bdd
end
