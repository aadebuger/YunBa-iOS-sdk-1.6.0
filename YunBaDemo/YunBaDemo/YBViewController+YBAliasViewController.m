//
//  YBViewController+YBAliasViewController.m
//  YunBa
//
//  Created by xuthief on 15/10/19.
//  Copyright © 2015年 SHENZHEN WEIZHIYUN TECHNOLOGY CO.LTD. All rights reserved.
//

#import "YBViewController.h"

@implementation YBViewController (YBAliasViewController)

#pragma mark -- alias view
- (IBAction)onAliasSetButton:(id)sender {
    if (![self.aliasSetText text]) {
        [self alertWithContent:@"no alias set"];
        [self.aliasSetText becomeFirstResponder];
        return;
    }
    
    [self hideAllKeyboard];
    
    NSString *alias = [self.aliasSetText text];
    NSString *aliasPrompt = alias.length ? [NSString stringWithFormat:@"set alias(%@)", alias] : @"unset alias";
    
    [YunBaService setAlias:alias resultBlock:^(BOOL succ, NSError *error) {
        if (succ) {
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] %@ succeed", aliasPrompt]];
        } else {
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] %@ failed: %@, recovery suggestion: %@", aliasPrompt, error, [error localizedRecoverySuggestion]]];
        }
    }];
    [self addMsgToTextView:[NSString stringWithFormat:@"[Demo] %@", aliasPrompt]];
}
- (IBAction)onAliasSetFinshed:(id)sender {
    [self onAliasSetButton:self.aliasSetButton];
}

- (IBAction)onAliasGetButton:(id)sender {
    [self hideAllKeyboard];
    
    [YunBaService getAlias:^(NSString *res, NSError *error) {
        if (error.code == kYBErrorNoError) {
            NSString *alias = res;
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] get alias(%@) succeed", alias]];
            [self.aliasGetText setText:alias];
        } else {
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] get alias failed: %@, recovery suggestion: %@", error, [error localizedRecoverySuggestion]]];
        }
    }];
    
    [self addMsgToTextView:[NSString stringWithFormat:@"[Demo] get alias"]];
}
@end
