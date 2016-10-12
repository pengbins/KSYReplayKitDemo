//
//  BroadcastViewController.m
//  KSYRKUploadExtUI
//
//  Created by yiqian on 9/28/16.
//  Copyright © 2016 ksyun. All rights reserved.
//

#import "BroadcastViewController.h"

@implementation BroadcastViewController

- (void)viewDidLoad {
    NSString * devCode = [[[[[UIDevice currentDevice] identifierForVendor] UUIDString] substringToIndex:3] lowercaseString];
    
    NSString *rtmpSrv = @"rtmp://test.uplive.ks-cdn.com/live";
    _rtmpUrl.text = [  NSString stringWithFormat:@"%@/%@", rtmpSrv, devCode];
}


- (IBAction)onStartBtn:(id)sender {
    [self userDidFinishSetup];
}
- (IBAction)onCancelBtn:(id)sender {
    [self userDidCancelSetup];
}

// Called when the user has finished interacting with the view controller and a broadcast stream can start
- (void)userDidFinishSetup {
    // Broadcast url that will be returned to the application
    NSURL *broadcastURL = [NSURL URLWithString: _rtmpUrl.text];
    // Service specific broadcast data example which will be supplied to the process extension during broadcast
    NSString *userID = @"user1";
    NSString *endpointURL = _rtmpUrl.text;
    
    NSInteger idx = _videoCodec.selectedSegmentIndex;
    NSString *videoCodec    = [_videoCodec titleForSegmentAtIndex:idx];
    
    NSDictionary *setupInfo = @{ @"userID" : userID,
                                 @"endpointURL" : endpointURL,
                                 @"videoCodec" : videoCodec};
    
    // Set broadcast settings
    RPBroadcastConfiguration *broadcastConfig = [[RPBroadcastConfiguration alloc] init];
    // Tell ReplayKit that the extension is finished setting up and can begin broadcasting
    [self.extensionContext completeRequestWithBroadcastURL:broadcastURL broadcastConfiguration:broadcastConfig setupInfo:setupInfo];
}

- (void)userDidCancelSetup {
    // Tell ReplayKit that the extension was
    // cancelled by the user
    NSError * err = [NSError errorWithDomain:@"com.ksyun.ios"
                                        code:-1
                                    userInfo:nil];
    [self.extensionContext cancelRequestWithError:err];
}

@end
