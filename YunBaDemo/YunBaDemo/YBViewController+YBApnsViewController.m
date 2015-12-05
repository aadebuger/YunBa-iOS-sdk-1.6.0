//
//  YBViewController+YBApnsViewController.m
//  YunBa
//
//  Created by xuthief on 15/10/19.
//  Copyright © 2015年 SHENZHEN WEIZHIYUN TECHNOLOGY CO.LTD. All rights reserved.
//

#import "YBViewController.h"
#import "YBAppDelegate.h"

@implementation YBViewController (YBApnsViewController)

- (void)initApnsStatus {
    BOOL apnsRegistered = [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
    [self.apnsEnableSwitch setOn:apnsRegistered];
    NSString *apnsMsg = [NSString stringWithFormat:@"[Apns] status => %@", apnsRegistered ? @"enabled" : @"disabled"];
    NSLog(@"%@", apnsMsg);
    [self addMsgToTextView:apnsMsg alert:YES];
}

- (void)didReceiveApn:(NSDictionary *)apn {
    NSString *apnContent = [NSString stringWithFormat:@"%@", apn];
    NSLog(@"received apn: %@", apnContent);
    NSString *apnMsg = [NSString stringWithFormat:@"[Apns] receive => %@", apnContent];
    [self addMsgToTextView:apnMsg];
}

#pragma mark -- apns view
- (IBAction)onApnsEnableSwitch:(id)sender {
    AppDelegate *ybAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    NSString *apnsMsg;
    switch (self.apnsEnableSwitch.isOn) {
        case YES: {
            [ybAppDelegate registerRemoteNotification];
            // after apns (un)permitted, apns registration result  callback will be invoked, transfer to
            //YBAppDelegate.m :: - (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
            //YBAppDelegate.m :: - (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error;
            NSLog(@"enabling apns");
            apnsMsg = @"[Apns] status => enabling";
        } break;
        case NO: {
            [ybAppDelegate unregisterRemoteNotification];
            NSLog(@"disabling apns");
            apnsMsg = [NSString stringWithFormat:@"[Apns] status => disabling"];
        } break;
    }
    [self addMsgToTextView:apnsMsg alert:YES];
}

- (IBAction)onClearBadgeButton:(id)sender {
    AppDelegate *ybAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [ybAppDelegate clearBadgeAndNotifications];
    NSLog(@"clear badge");
    NSString *apnsMsg = [NSString stringWithFormat:@"[Apns] badge => 0"];
    [self addMsgToTextView:apnsMsg];
}
@end
