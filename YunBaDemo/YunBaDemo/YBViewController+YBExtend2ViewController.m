//
//  YBViewController+YBExtend2ViewController.m
//  YunBa
//
//  Created by xuthief on 15/10/19.
//  Copyright © 2015年 SHENZHEN WEIZHIYUN TECHNOLOGY CO.LTD. All rights reserved.
//

#import "YBViewController.h"

@implementation YBViewController (YBExtend2ViewController)
#pragma mark -- v2 get topic list /get state /get alias list view
- (IBAction)onTopicListV2GetButton:(id)sender {
    [self hideAllKeyboard];
    
    NSString *alias = [[self.getTopicListV2Text text] length] ? [self.getTopicListV2Text text]:nil;
    [YunBaService getTopicListV2:alias resultBlock:^(NSDictionary *res, NSError *error) {
        if (error.code == kYBErrorNoError) {
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] get topic list v2 (%@) of alias (%@) succeed", [res objectForKey:kYBGetTopicListTopicsKey], alias]];
        } else {
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] get topic list v2 of alias (%@) failed: %@, recovery suggestion: %@", alias, error, [error localizedRecoverySuggestion]]];
        }
    }];
    [self addMsgToTextView:[NSString stringWithFormat:@"[Demo] get topic list v2 of alias %@", alias]];
}

- (IBAction)onTopicListV2GetFinshed:(id)sender {
    [self onTopicListV2GetButton:self.getTopicListV2Button];
}

- (IBAction)onStateV2GetButton:(id)sender {
    if (![[self.getStateV2Text text] length]) {
        [self alertWithContent:@"no alias set"];
        [self.getStateV2Text becomeFirstResponder];
        return;
    }
    [self hideAllKeyboard];
    
    NSString *alias = [self.getStateV2Text text];
    
    [YunBaService getStateV2:alias resultBlock:^(NSDictionary *res, NSError *error) {
        if (error.code == kYBErrorNoError) {
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] get state v2 (%@) of alias (%@) succeed", [res objectForKey:kYBGetStateStateKey], alias]];
        } else {
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] get state v2 of alias (%@) failed: %@, recovery suggestion: %@", alias, error, [error localizedRecoverySuggestion]]];
        }
    }];
    [self addMsgToTextView:[NSString stringWithFormat:@"[Demo] get state v2 of alias %@", alias]];
}

- (IBAction)onStateV2GetFinshed:(id)sender {
    [self onStateV2GetButton:self.getStateV2Button];
}

- (IBAction)onAliasListV2GetButton:(id)sender {
    if (![[self.getAliasListV2Text text] length]) {
        [self alertWithContent:@"no topic set"];
        [self.getAliasListV2Text becomeFirstResponder];
        return;
    }
    [self hideAllKeyboard];
    
    NSString *topic = [self.getAliasListV2Text text];
    [YunBaService getAliasListV2:topic resultBlock:^(NSDictionary *res, NSError *error) {
        if (error.code == kYBErrorNoError) {
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] get alias list v2 count %@ :(%@) of topic (%@) succeed", [res objectForKey:kYBGetAliasListOccupancyKey], [res objectForKey:kYBGetAliasListAliasKey], topic]];
        } else {
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] get alias list v2 of topic (%@) failed: %@, recovery suggestion: %@", topic, error, [error localizedRecoverySuggestion]]];
        }
    }];
    [self addMsgToTextView:[NSString stringWithFormat:@"[Demo] get alias list v2 of topic %@", topic]];
}

- (IBAction)onAliasListV2GetFinshed:(id)sender {
    [self onAliasListV2GetButton:self.getAliasListV2Button];
}

@end
