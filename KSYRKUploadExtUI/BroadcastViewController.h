//
//  BroadcastViewController.h
//  KSYRKUploadExtUI
//
//  Created by yiqian on 9/28/16.
//  Copyright © 2016 ksyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReplayKit/ReplayKit.h>

@interface BroadcastViewController : UIViewController
/// rtmp 地址
@property (weak, nonatomic) IBOutlet UITextField *rtmpUrl;

@property (weak, nonatomic) IBOutlet UISegmentedControl *videoCodec;

@end
