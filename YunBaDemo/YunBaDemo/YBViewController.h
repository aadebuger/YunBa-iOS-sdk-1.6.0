//
//  YBViewController.h
//  yunba-demo
//
//  Created by YunBa on 13-12-6.
//  Copyright (c) 2013年 SHENZHEN WEIZHIYUN TECHNOLOGY CO.LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YunBaService.h"

@interface YBViewController : UIViewController

- (void)hideAllKeyboard;
- (void)addMsgToTextView:(NSString *)message;
- (void)addMsgToTextView:(NSString *)message alert:(BOOL)alert;
- (void)alertWithContent:(NSString *)contet;

// common view
@property (retain, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *yunbaScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *demoScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *messageListScrollView;

// pub/sub view
@property (strong, nonatomic) IBOutlet UIView *pubSubView;
@property (retain, nonatomic) IBOutlet UISwitch *subscribedSwitch;
@property (retain, nonatomic) IBOutlet UITextField *subTopicText;
@property (retain, nonatomic) IBOutlet UIButton *pubButton;
@property (retain, nonatomic) IBOutlet UITextField *pubContentText;
@property (retain, nonatomic) IBOutlet UITextField *pubTopicText;
@property (weak, nonatomic) IBOutlet UISegmentedControl *pubQosSegment;

// alias view
@property (strong, nonatomic) IBOutlet UIView *aliasView;
@property (retain, nonatomic) IBOutlet UIButton *aliasSetButton;
@property (retain, nonatomic) IBOutlet UITextField *aliasSetText;
@property (retain, nonatomic) IBOutlet UIButton *aliasGetButton;
@property (retain, nonatomic) IBOutlet UITextField *aliasGetText;

// presence view
@property (strong, nonatomic) IBOutlet UIView *presenceView;
@property (retain, nonatomic) IBOutlet UISwitch *presenceSubSwitch;
@property (retain, nonatomic) IBOutlet UITextField *presenceSubText;
@property (retain, nonatomic) IBOutlet UIButton *aliasPubButton;
@property (retain, nonatomic) IBOutlet UITextField *aliasPubContentText;
@property (retain, nonatomic) IBOutlet UITextField *aliasPubText;
@property (weak, nonatomic) IBOutlet UISegmentedControl *aliasPubQosSegment;

// get topic list /get alias list /get state view
@property (strong, nonatomic) IBOutlet UIView *getsView;
@property (retain, nonatomic) IBOutlet UIButton *getTopicListButton;
@property (retain, nonatomic) IBOutlet UITextField *getTopicListText;
@property (retain, nonatomic) IBOutlet UIButton *getStateButton;
@property (retain, nonatomic) IBOutlet UITextField *getStateText;
@property (retain, nonatomic) IBOutlet UIButton *getAliasListButton;
@property (retain, nonatomic) IBOutlet UITextField *getAliasListText;

// pub2 view
@property (strong, nonatomic) IBOutlet UIView *pub2View;
@property (weak, nonatomic) IBOutlet UIButton *pub2Button;
@property (weak, nonatomic) IBOutlet UISegmentedControl *pub2TypeSegment;
@property (weak, nonatomic) IBOutlet UITextField *pub2TopicText;
@property (weak, nonatomic) IBOutlet UITextField *pub2ContentText;
@property (weak, nonatomic) IBOutlet UITextField *pub2AlertText;
@property (weak, nonatomic) IBOutlet UITextField *pub2BadgeText;
@property (weak, nonatomic) IBOutlet UISegmentedControl *pub2SoundSegment;
@property (weak, nonatomic) IBOutlet UITextField *pub2Key1Text;
@property (weak, nonatomic) IBOutlet UITextField *pub2Value1Text;

//v2 get topic list /get alias list /get state view
@property (strong, nonatomic) IBOutlet UIView *getsV2View;
@property (retain, nonatomic) IBOutlet UIButton *getTopicListV2Button;
@property (retain, nonatomic) IBOutlet UITextField *getTopicListV2Text;
@property (retain, nonatomic) IBOutlet UIButton *getStateV2Button;
@property (retain, nonatomic) IBOutlet UITextField *getStateV2Text;
@property (retain, nonatomic) IBOutlet UIButton *getAliasListV2Button;
@property (retain, nonatomic) IBOutlet UITextField *getAliasListV2Text;

// apns view
@property (strong, nonatomic) IBOutlet UIView *apnsView;
@property (weak, nonatomic) IBOutlet UISwitch *apnsEnableSwitch;
@property (weak, nonatomic) IBOutlet UITextField *deviceTokenText;

@end

@interface YBViewController (YBPubSubViewController)    @end
@interface YBViewController (YBAliasViewController)     @end
@interface YBViewController (YBPresenceViewController)  @end
@interface YBViewController (YBExtendViewController)    @end
@interface YBViewController (YBPubSub2ViewController)   @end
@interface YBViewController (YBExtend2ViewController)   @end
@interface YBViewController (YBApnsViewController)
- (void)initApnsStatus;
- (void)didReceiveApn:(NSDictionary *)apn;
@end
