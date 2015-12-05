//
//  YBViewController+YBPubSub2ViewController.m
//  YunBa
//
//  Created by xuthief on 15/10/19.
//  Copyright © 2015年 SHENZHEN WEIZHIYUN TECHNOLOGY CO.LTD. All rights reserved.
//

#import "YBViewController.h"

@implementation YBViewController (YBPubSub2ViewController)

#pragma mark -- pub2 view
- (IBAction)onPub2Button:(id)sender {
    if (![[self.pub2TopicText text] length]) {
        [self alertWithContent:@"no pub topic/alias set"];
        [self.pub2TopicText becomeFirstResponder];
        return;
    }
    
    [self hideAllKeyboard];
    
    NSString *dest = [self.pub2TopicText text];
    NSData *data = [[self.pub2ContentText text] dataUsingEncoding:NSUTF8StringEncoding];
    YBPublish2Option *option = [[YBPublish2Option alloc] init];
    
    NSString *alert = [[self.pub2AlertText text] length] ? [self.pub2AlertText text] : nil;
    NSNumber *badge = [[self.pub2BadgeText text] length] ? [NSNumber numberWithInt:[[self.pub2BadgeText text] intValue]] : nil;
    NSString *sound = [self.pub2SoundSegment selectedSegmentIndex] != 0 ? [self.pub2SoundSegment titleForSegmentAtIndex:[self.pub2SoundSegment selectedSegmentIndex]] : nil;
    NSDictionary *extra = [[self.pub2Key1Text text] length] ? @{[self.pub2Key1Text text] : [self.pub2Value1Text text]} : nil;
    
    if (alert || badge || sound || extra) {
        YBApnOption *apnOption = [YBApnOption optionWithAlert:alert badge:badge sound:sound contentAvailable:nil extra:extra];
        [option setApnOption:apnOption];
    }
    
    if ([self.pub2TypeSegment selectedSegmentIndex] == 0) {
        [YunBaService publish2:dest data:data option:option resultBlock:^(BOOL succ, NSError *error){
            if (succ) {
                [self addMsgToTextView:[NSString stringWithFormat:@"[result] publish2 data(%@) to topic(%@) succeed", [self.pub2ContentText text], dest]];
            } else {
                [self addMsgToTextView:[NSString stringWithFormat:@"[result] publish data(%@) to topic(%@) failed: %@, recovery suggestion: %@", [self.pub2ContentText text], dest, error,  [error localizedRecoverySuggestion]]];
            }
        }];
        
        [self addMsgToTextView:[NSString stringWithFormat:@"[Demo] publish data %@ toTopic %@ with ApnOption(%@|%@|%@|%@)", [self.pub2ContentText text], dest, alert, badge, sound, extra]];
    } else {
        [YunBaService publish2ToAlias:dest data:data option:option resultBlock:^(BOOL succ, NSError *error){
            if (succ) {
                [self addMsgToTextView:[NSString stringWithFormat:@"[result] publish2 data(%@) to alias(%@) succeed", [self.pub2ContentText text], dest]];
            } else {
                [self addMsgToTextView:[NSString stringWithFormat:@"[result] publish data(%@) to alias(%@) failed: %@, recovery suggestion: %@", [self.pub2ContentText text], dest, error,  [error localizedRecoverySuggestion]]];
            }
        }];
        
        [self addMsgToTextView:[NSString stringWithFormat:@"[Demo] publish data %@ toAlias %@ with ApnOption(%@|%@|%@|%@)", [self.pub2ContentText text], dest, alert, badge, sound, extra]];
    }
}

- (IBAction)onPub2TopicFinshed:(id)sender {
    [self.pub2ContentText becomeFirstResponder];
}
- (IBAction)onPub2ContentFinshed:(id)sender {
    [self.pub2AlertText becomeFirstResponder];
}
- (IBAction)onPub2AlertFinshed:(id)sender {
    [self.pub2BadgeText becomeFirstResponder];
}
- (IBAction)onPub2BadgeFinshed:(id)sender {
    [self.pub2Key1Text becomeFirstResponder];
}
- (IBAction)onPub2Key1Finshed:(id)sender {
    [self.pub2Value1Text becomeFirstResponder];
}
- (IBAction)onPub2Value1Finshed:(id)sender {
    [self onPub2Button:self.pub2Button];
}

@end
