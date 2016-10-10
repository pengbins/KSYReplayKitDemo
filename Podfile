platform :ios, '7.0'
inhibit_all_warnings!
use_frameworks!

target 'KSYRKUploadExt' do
	pod 'GPUImage'
	pod 'libksygpulive/libksygpulive',  :git => 'git@newgit.op.ksyun.com:sdk/KSYLive_iOS.git', :branch => 'Streamer_t1.8.3.0_562'
end
  
post_install do |installer|
  installer.pods_project.targets.each do |target|
    puts "!!!! #{target.name}"
  end
end
