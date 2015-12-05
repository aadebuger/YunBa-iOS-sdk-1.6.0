//
//  YBViewController+YBExtendViewController.m
//  YunBa
//
//  Created by xuthief on 15/10/19.
//  Copyright © 2015年 SHENZHEN WEIZHIYUN TECHNOLOGY CO.LTD. All rights reserved.
//

#import "YBViewController.h"

@implementation YBViewController (YBExtendViewController)

#pragma mark -- get topic list /get state /get alias list view
- (IBAction)onTopicListGetButton:(id)sender {
    [self hideAllKeyboard];
    
    NSString *alias = [[self.getTopicListText text] length] ? [self.getTopicListText text]:nil;
    [YunBaService getTopicList:alias resultBlock:^(NSArray *res, NSError *error) {
        if (error.code == kYBErrorNoError) {
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] get topic list (%@) of alias (%@) succeed", res, alias]];
        } else {
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] get topic list of alias (%@) failed: %@, recovery suggestion: %@", alias, error, [error localizedRecoverySuggestion]]];
        }
    }];
    [self addMsgToTextView:[NSString stringWithFormat:@"[Demo] get topic list of alias %@", alias]];
}

- (IBAction)onTopicListGetFinshed:(id)sender {
    [self onTopicListGetButton:self.getTopicListButton];
}

- (IBAction)onStateGetButton:(id)sender {
    if (![[self.getStateText text] length]) {
        [self alertWithContent:@"no alias set"];
        [self.getStateText becomeFirstResponder];
        return;
    }
    [self hideAllKeyboard];
    
    NSString *alias = [self.getStateText text];
    [YunBaService getState:alias resultBlock:^(NSString *res, NSError *error) {
        if (error.code == kYBErrorNoError) {
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] get state (%@) of alias (%@) succeed", res, alias]];
        } else {
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] get state of alias (%@) failed: %@, recovery suggestion: %@", alias, error, [error localizedRecoverySuggestion]]];
        }
    }];
    [self addMsgToTextView:[NSString stringWithFormat:@"[Demo] get state of alias %@", alias]];
}

- (IBAction)onStateGetFinshed:(id)sender {
    [self onStateGetButton:self.getStateButton];
}

- (IBAction)onAliasListGetButton:(id)sender {
    if (![[self.getAliasListText text] length]) {
        [self alertWithContent:@"no topic set"];
        [self.getAliasListText becomeFirstResponder];
        return;
    }
    [self hideAllKeyboard];
    
    NSString *topic = [self.getAliasListText text];
    [YunBaService getAliasList:topic resultBlock:^(NSArray *resArray, size_t resCount, NSError *error) {
        if (error.code == kYBErrorNoError) {
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] get alias list count %u :(%@) of topic (%@) succeed", (uint)resCount, resArray, topic]];
        } else {
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] get alias list of topic (%@) failed: %@, recovery suggestion: %@", topic, error, [error localizedRecoverySuggestion]]];
        }
    }];
    [self addMsgToTextView:[NSString stringWithFormat:@"[Demo] get alias list of topic %@", topic]];
}

- (IBAction)onAliasListGetFinshed:(id)sender {
    [self onAliasListGetButton:self.getAliasListButton];
}

@end
