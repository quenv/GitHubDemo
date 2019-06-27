# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

  
def sharePods
  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'
  pod 'Alamofire', '4.7.3'
  pod 'Moya-ObjectMapper/RxSwift', :git => 'https://github.com/khoren93/Moya-ObjectMapper.git', :branch => 'moya14'
  pod 'Moya/RxSwift', '14.0.0-alpha.1' 
  pod 'KeychainAccess', '~> 3.0' 
  pod 'CocoaLumberjack/Swift', '~> 3.0'

end

target 'GitHubDemo' do 
# Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  # Pods for GitHubDemo
  sharePods
  target 'GitHubDemoTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'GitHubDemoUITests' do
    inherit! :search_paths
    # Pods for testing
   sharePods
  end
end


