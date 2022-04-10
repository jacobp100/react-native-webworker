require 'json'

fabric_enabled = ENV['RCT_NEW_ARCH_ENABLED']

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

folly_compiler_flags = '-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1 -Wno-comma -Wno-shorten-64-to-32'

Pod::Spec.new do |s|
  s.name         = "react-native-webworker"
  s.version      = package['version']
  s.summary      = package['description']
  s.license      = package['license']

  s.authors      = package['author']
  s.homepage     = package['homepage']
  s.platforms    = { :ios => "11.0", :tvos => "11.0" }
  s.source       = { :git => "https://github.com/jacobp100/react-native-webworker.git", :tag => "v#{s.version}" }

  s.source_files = "ios/**/*.{h,m,mm}"

  s.dependency "React"
  s.dependency "React-CoreModules"

  if ENV['RCT_NEW_ARCH_ENABLED'] == '1' then
    s.compiler_flags = folly_compiler_flags + " -DRCT_NEW_ARCH_ENABLED=1"
    s.pod_target_xcconfig  = {
      "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/boost\" \"$(PODS_ROOT)/Headers/Private/React-Core\"",
      "CLANG_CXX_LANGUAGE_STANDARD" => "c++17",
    }

    s.dependency "React-Codegen"
    s.dependency "RCT-Folly"
    s.dependency "RCTRequired"
    s.dependency "ReactCommon/turbomodule/core"
  end
end
