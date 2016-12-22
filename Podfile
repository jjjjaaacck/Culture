platform :ios, '10.0'
use_frameworks!

target 'kj' do
    pod 'Alamofire'
    pod 'SwiftyJSON'
    pod 'ChameleonFramework'
    pod 'GoogleMaps'
    pod 'GooglePlaces'
    pod 'GooglePlacePicker'
    pod 'RealmSwift'
    pod 'SnapKit'
    pod 'Bolts-Swift'
    pod 'Kingfisher'
    pod 'R.swift'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
