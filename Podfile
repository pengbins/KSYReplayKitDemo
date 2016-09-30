platform :ios, '7.0'
inhibit_all_warnings!
use_frameworks!

target 'KSYRKUploadExt' do
	pod 'GPUImage'
	pod 'libksygpulive/libksygpulive',  :path => '../proj/KSYLive_iOS/'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    puts "!!!! #{target.name}"
  end
end
