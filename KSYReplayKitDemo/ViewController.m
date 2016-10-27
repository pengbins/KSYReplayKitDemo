//
//  ViewController.m
//  KSYReplayKitDemo
//
//  Created by yiqian on 9/28/16.
//  Copyright © 2016 ksyun. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <ReplayKit/ReplayKit.h>

#import "ViewController.h"

#define SYSTEM_VERSION_GE_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface ViewController ()<RPBroadcastActivityViewControllerDelegate, RPBroadcastControllerDelegate> {
}
@property (nonatomic, strong) UIButton * btnShare;
@property (nonatomic, weak)   RPBroadcastController *broadcastController;
@property (nonatomic, strong) UIWindow *overlayWindow;
@property (nonatomic, weak)   UIView   *cameraPreview;
@property NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(SYSTEM_VERSION_GE_TO(@"10.0")) {
        [self setupBroadcastUI];
    }
    _btnShare = [[UIButton alloc] init];
    [self.view addSubview:_btnShare];
    _btnShare.frame = CGRectMake(30, 130, 164, 164);
    [_btnShare setTitle:@"share" forState:UIControlStateNormal];
    _btnShare.backgroundColor = [UIColor redColor];
    [_btnShare addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchDown];
    _timer =  [NSTimer scheduledTimerWithTimeInterval:0.2
                                               target:self
                                             selector:@selector(onTimer:)
                                             userInfo:nil
                                              repeats:YES];
    
}

- (void)setupBroadcastUI {
    UIViewController *rootViewController = [[UIViewController alloc] init];
    self.overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.overlayWindow.hidden = NO;
    self.overlayWindow.userInteractionEnabled = NO;
    self.overlayWindow.backgroundColor = nil;
    self.overlayWindow.rootViewController = rootViewController;
    
    RPScreenRecorder * recorder = [RPScreenRecorder sharedRecorder];
    
    if([recorder respondsToSelector:@selector(setCameraEnabled:)]) {
        // This test will fail on devices < iOS 9
        [RPScreenRecorder sharedRecorder].microphoneEnabled = YES;
        [RPScreenRecorder sharedRecorder].cameraEnabled = YES;
        [[AVAudioSession sharedInstance] requestRecordPermission: ^(BOOL granted){
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)onTimer:(NSTimer *)theTimer{
}

- (void)pressBtn: (UIButton*)btn {
    if (btn == _btnShare) {
        [self toggleBroadcast];
    }
}
- (void)toggleBroadcast {
    __weak ViewController* bSelf = self;
    if (![RPScreenRecorder sharedRecorder].isRecording) {
        [RPBroadcastActivityViewController loadBroadcastActivityViewControllerWithHandler:^(RPBroadcastActivityViewController * _Nullable broadcastActivityViewController, NSError * _Nullable error) {
            if (error) {
                NSLog(@"RPBroadcast err %@", [error localizedDescription]);
            }
            broadcastActivityViewController.delegate = bSelf;
            broadcastActivityViewController.modalPresentationStyle = UIModalPresentationPopover;
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                broadcastActivityViewController.popoverPresentationController.sourceRect = bSelf.btnShare.frame;
                broadcastActivityViewController.popoverPresentationController.sourceView = bSelf.btnShare;
            }
            [bSelf presentViewController:broadcastActivityViewController animated:YES completion:nil];
        }];
    } else {
        // We are currently broadcasting, disconnect.
        [self.broadcastController finishBroadcastWithHandler:^(NSError * _Nullable error) {
        }];
    }
}

#pragma mark - Broadcasting
- (void)broadcastActivityViewController:(RPBroadcastActivityViewController *) broadcastActivityViewController
       didFinishWithBroadcastController:(RPBroadcastController *)broadcastController
                                  error:(NSError *)error {
    [broadcastActivityViewController dismissViewControllerAnimated:YES
                                                        completion:nil];
    NSLog(@"BundleID %@", broadcastController.broadcastExtensionBundleID);
    self.broadcastController = broadcastController;
    if (error) {
        NSLog(@"BAC: %@ didFinishWBC: %@, err: %@",
              broadcastActivityViewController,
              broadcastController,
              error);
        return;
    }
    __weak ViewController* bSelf = self;
    [broadcastController startBroadcastWithHandler:^(NSError * _Nullable error) {
        if (!error) {
            bSelf.broadcastController.delegate = self;
            bSelf.btnShare.backgroundColor = [UIColor greenColor];
            
            UIView* cameraView = [[RPScreenRecorder sharedRecorder] cameraPreviewView];
            bSelf.cameraPreview = cameraView;
            if(cameraView) {
                cameraView.frame = CGRectMake(30, 300, 164, 164);
                [bSelf.view addSubview:cameraView];
            }
        }
        else {
            bSelf.btnShare.backgroundColor = [UIColor redColor];
            NSLog(@"startBroadcast %@",error.localizedDescription);
        }
    }];
}

// Watch for service info from broadcast service
- (void)broadcastController:(RPBroadcastController *)broadcastController
       didUpdateServiceInfo:(NSDictionary <NSString *, NSObject <NSCoding> *> *)serviceInfo {
    NSLog(@"didUpdateServiceInfo: %@", serviceInfo);
}

// Broadcast service encountered an error
- (void)broadcastController:(RPBroadcastController *)broadcastController
         didFinishWithError:(NSError *)error {
    NSLog(@"didFinishWithError: %@", error);
}

@end
