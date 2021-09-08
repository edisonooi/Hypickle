# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'HypixelStats' do
  use_frameworks!

  pod 'SwiftyJSON', '~> 4.0'
  pod 'Alamofire', '~> 5.4'
  pod 'AMScrollingNavbar', '~> 5.1.0'
  
  plugin 'cocoapods-keys', {
    :project => "HypixelStats",
    :keys => [
      "HypixelAPIKey"
    ]}

post_install do |installer|
    copy_pods_resources_path = "Pods/Target Support Files/Pods-IconTest/Pods-HypixelStats-resources.sh"
    string_to_replace = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"'
    assets_compile_with_app_icon_arguments = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}" --app-icon "${ASSETCATALOG_COMPILER_APPICON_NAME}" --output-partial-info-plist "${BUILD_DIR}/assetcatalog_generated_info.plist"'
    text = File.read(copy_pods_resources_path)
    new_contents = text.gsub(string_to_replace, assets_compile_with_app_icon_arguments)
    File.open(copy_pods_resources_path, "w") {|file| file.puts new_contents }
end

  # Pods for HypixelStats

  target 'HypixelStatsTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'HypixelStatsUITests' do
    # Pods for testing
  end

end
