//
//  YBViewController+YBPubSubViewController.m
//  YunBa
//
//  Created by xuthief on 15/10/19.
//  Copyright © 2015年 SHENZHEN WEIZHIYUN TECHNOLOGY CO.LTD. All rights reserved.
//

#import "YBViewController.h"

@implementation YBViewController (YBPubSubViewController)


#pragma mark -- pubSub view
- (IBAction)onSwitchSub:(id)sender {
    if (![[self.subTopicText text] length]) {
        [self.subscribedSwitch setOn:![self.subscribedSwitch isOn] animated:YES];
        [self alertWithContent:@"no sub topic set"];
        [self.subTopicText becomeFirstResponder];
        return;
    }
    [self hideAllKeyboard];
    if ([self.subscribedSwitch isOn]) {
        NSString *topic = [self.subTopicText text];
        [YunBaService subscribe:topic resultBlock:^(BOOL succ, NSError *error){
            if (succ) {
                [self addMsgToTextView:[NSString stringWithFormat:@"[result] subscribe to topic(%@) succeed", topic]];
            } else {
                [self addMsgToTextView:[NSString stringWithFormat:@"[result] subscribe to topic(%@) failed: %@, recovery suggestion: %@", topic, error, [error localizedRecoverySuggestion]]];
            }
        }];
        [self addMsgToTextView:[NSString stringWithFormat:@"[Demo]  subscribe topic: %@", [self.subTopicText text]]];
    } else {
        NSString *topic = [self.subTopicText text];
        [YunBaService unsubscribe:topic resultBlock:^(BOOL succ, NSError *error){
            if (succ) {
                [self addMsgToTextView:[NSString stringWithFormat:@"[result] unsubscribe to topic(%@) succeed", topic]];
            } else {
                [self addMsgToTextView:[NSString stringWithFormat:@"[result] unsubscribe to topic(%@) failed: %@, recovery suggestion: %@", topic, error, [error localizedRecoverySuggestion]]];
            }
        }];
        [self addMsgToTextView:[NSString stringWithFormat:@"[Demo]  unsubscribe topic: %@", [self.subTopicText text]]];
    }
}
- (IBAction)onSubTopicChanged:(id)sender {
    if ([self.subscribedSwitch isOn]) {
        [self.subscribedSwitch setOn:NO animated:YES];
    }
}
- (IBAction)onSubTopicFinshed:(id)sender {
    [self.subscribedSwitch setOn:![self.subscribedSwitch isOn] animated:YES];
    [self onSwitchSub:self.subscribedSwitch];
}

- (IBAction)onPubButton:(id)sender {
    if (![[self.pubTopicText text] length]) {
        [self alertWithContent:@"no pub topic set"];
        [self.pubTopicText becomeFirstResponder];
        return;
    }
    
    [self hideAllKeyboard];
    
    NSString *topic = [self.pubTopicText text];
    NSData *data = [[self.pubContentText text] dataUsingEncoding:NSUTF8StringEncoding];
    UInt8 qosLevel = [self.pubQosSegment selectedSegmentIndex];
    BOOL isRetained = NO;
    [YunBaService publish:topic data:data option:[YBPublishOption optionWithQos:qosLevel retained:NO] resultBlock:^(BOOL succ, NSError *error){
        if (succ) {
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] publish data(%@) to topic(%@) succeed", [self.pubContentText text], topic]];
        } else {
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] publish data(%@) to topic(%@) failed: %@, recovery suggestion: %@", [self.pubContentText text], topic, error,  [error localizedRecoverySuggestion]]];
        }
    }];
    
    [self addMsgToTextView:[NSString stringWithFormat:@"[Demo] publish data %@ toTopic %@ atQos %hhu retainFlag %d", [self.pubContentText text], [self.pubTopicText text], qosLevel, isRetained]];
}

- (IBAction)onPubTopicFinshed:(id)sender {
    [self.pubContentText becomeFirstResponder];
}
- (IBAction)onPubContentFinshed:(id)sender {
    [self onPubButton:self.pubButton];
}

@end
