//
//  YBViewController+YBPresenceViewController.m
//  YunBa
//
//  Created by xuthief on 15/10/19.
//  Copyright © 2015年 SHENZHEN WEIZHIYUN TECHNOLOGY CO.LTD. All rights reserved.
//

#import "YBViewController.h"

@implementation YBViewController (YBPresenceViewController)
#pragma mark -- subscribe presence / publish to alias view
- (IBAction)onPresenceSubSwitch:(id)sender {
    if (![[self.presenceSubText text] length]) {
        [self.presenceSubSwitch setOn:![self.presenceSubSwitch isOn] animated:YES];
        [self alertWithContent:@"no sub alias set"];
        [self.presenceSubText becomeFirstResponder];
        return;
    }
    [self hideAllKeyboard];
    NSString *alias = [self.presenceSubText text];
    
    if ([self.presenceSubSwitch isOn]) {
        [YunBaService subscribePresence:alias resultBlock:^(BOOL succ, NSError *error) {
            if (succ) {
                [self addMsgToTextView:[NSString stringWithFormat:@"[result] subscribe presence to alias(%@) succeed", alias]];
            } else {
                [self addMsgToTextView:[NSString stringWithFormat:@"[result] subscribe presence to alias(%@) failed: %@, recovery suggestion: %@", alias, error, [error localizedRecoverySuggestion]]];
            }
        }];
        [self addMsgToTextView:[NSString stringWithFormat:@"[Demo]  subscribe presence to alias %@", alias]];
    } else {
        [YunBaService unsubscribePresence:alias resultBlock:^(BOOL succ, NSError *error) {
            if (succ) {
                [self addMsgToTextView:[NSString stringWithFormat:@"[result] unsubscribe presence to alias(%@) succeed", alias]];
            } else {
                [self addMsgToTextView:[NSString stringWithFormat:@"[result] unsubscribe presence to alias(%@) failed: %@, recovery suggestion: %@", alias, error, [error localizedRecoverySuggestion]]];
            }
        }];
        [self addMsgToTextView:[NSString stringWithFormat:@"[Demo]  unsubscribe presence to alias %@", alias]];
    }
}
- (IBAction)onPresenceSubAliasChanged:(id)sender {
    if ([self.presenceSubSwitch isOn]) {
        [self.presenceSubSwitch setOn:NO animated:YES];
    }
}
- (IBAction)onPresenceSubFinshed:(id)sender {
    [self.presenceSubSwitch setOn:![self.presenceSubSwitch isOn] animated:YES];
    [self onPresenceSubSwitch:self.presenceSubSwitch];
}

- (IBAction)onAliasPubButton:(id)sender {
    if (![[self.aliasPubText text] length]) {
        [self alertWithContent:@"no alias set"];
        [self.aliasPubText becomeFirstResponder];
        return;
    }
    
    [self hideAllKeyboard];
    
    NSString *alias = [self.aliasPubText text];
    NSData *data = [[self.aliasPubContentText text] dataUsingEncoding:NSUTF8StringEncoding];
    UInt8 qosLevel = [self.aliasPubQosSegment selectedSegmentIndex];
    BOOL isRetained = NO;
    [YunBaService publishToAlias:alias data:data option:[YBPublishOption optionWithQos:qosLevel retained:NO] resultBlock:^(BOOL succ, NSError *error){
        if (succ) {
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] publish data(%@) to alias(%@) succeed", [self.aliasPubContentText text], alias]];
        } else {
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] publish data(%@) to alias(%@) failed: %@, recovery suggestion: %@", [self.aliasPubContentText text], alias, error, [error localizedRecoverySuggestion]]];
        }
    }];
    
    [self addMsgToTextView:[NSString stringWithFormat:@"[Demo] publish data %@ to alias %@ atQos %hhu retainFlag %d", [self.aliasPubContentText text], alias, qosLevel, isRetained]];
}

- (IBAction)onAliasPubTopicFinshed:(id)sender {
    [self.aliasPubContentText becomeFirstResponder];
}
- (IBAction)onAliasPubContentFinshed:(id)sender {
    [self onAliasPubButton:self.aliasPubButton];
}

@end
