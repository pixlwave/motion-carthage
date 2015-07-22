# encoding: utf-8

unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

module Motion; module Project
  class Config
    attr_accessor :carts
  end
end; end

namespace "build" do
  task :device => 'carthage:device'
  task :simulator => 'carthage:simulator'
  task :development => 'carthage:mac'
  task :release => 'carthage:mac'
end

namespace :carthage do
  desc "Thin and embed Carthage frameworks"
  task :device do
    unless App.config.carts.nil?
      # carthage copy-frameworks
      App.info "Thin", App.config.carts.join(', ')
      copy_frameworks(App.config.archs["iPhoneOS"].join(" "))
      embed_frameworks(App.config.archs["iPhoneOS"].join(" "))
    end
  end

  desc "Embed Carthage frameworks"
  task :simulator do
    # embed universal binary
    App.config.embedded_frameworks += App.config.carts.map { |framework| "Carthage/Build/iOS/#{framework}.framework" } unless App.config.carts.nil?
  end

  desc "Embed Carthage frameworks"
  task :mac do
    # embed universal binary
    App.config.embedded_frameworks += App.config.carts.map { |framework| "Carthage/Build/Mac/#{framework}.framework" } unless App.config.carts.nil?
  end
end

def copy_frameworks(archs)
  ENV["BUILT_PRODUCTS_DIR"] = File.expand_path("build/Carts")
  ENV["FRAMEWORKS_FOLDER_PATH"] = archs
  ENV["VALID_ARCHS"] = archs
  ENV["SCRIPT_INPUT_FILE_COUNT"] = "#{App.config.carts.count}"

  App.config.carts.each_with_index do |framework, i|
    ENV["SCRIPT_INPUT_FILE_#{i}"] = File.expand_path("Carthage/Build/iOS/#{framework}.framework")
  end

  sh "carthage copy-frameworks"
end

def embed_frameworks(archs)
  App.config.embedded_frameworks += App.config.carts.map { |framework| "build/Carts/#{archs}/#{framework}.framework" }
end


#### Unused ####

# Array of Frameworks - won't necessarily match built framework name :(
def carthage_frameworks
  File.readlines('Cartfile').map { |line| carthage_parse(line) }.reject { |framework| framework == nil }
end

def carthage_parse(line)
  line.split(',').first.gsub('github', '').gsub('"', '').strip.split('/').last
end


# Swift is needed for some frameworks: not callable due to lack of headers :(
# copy_libswift("iPhoneSimulator")
def copy_libswift(platform)
  cp "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/#{platform.downcase}/libswiftCore.dylib", File.join(File.dirname(App.config.app_bundle_executable(platform)), "Frameworks")
  cp "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/#{platform.downcase}/libswiftDarwin.dylib", File.join(File.dirname(App.config.app_bundle_executable(platform)), "Frameworks")
  cp "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/#{platform.downcase}/libswiftDispatch.dylib", File.join(File.dirname(App.config.app_bundle_executable(platform)), "Frameworks")
  cp "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/#{platform.downcase}/libswiftFoundation.dylib", File.join(File.dirname(App.config.app_bundle_executable(platform)), "Frameworks")
  cp "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/#{platform.downcase}/libswiftObjectiveC.dylib", File.join(File.dirname(App.config.app_bundle_executable(platform)), "Frameworks")
  cp "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/#{platform.downcase}/libswiftSecurity.dylib", File.join(File.dirname(App.config.app_bundle_executable(platform)), "Frameworks")
  cp "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/#{platform.downcase}/libswiftCoreGraphics.dylib", File.join(File.dirname(App.config.app_bundle_executable(platform)), "Frameworks")
end
