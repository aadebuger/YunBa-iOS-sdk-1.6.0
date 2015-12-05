//
//  YBViewController.m
//  yunba-demo
//
//  Created by YunBa on 13-12-6.
//  Copyright (c) 2013年 SHENZHEN WEIZHIYUN TECHNOLOGY CO.LTD. All rights reserved.
//

#import "YBViewController.h"
#import "YunBaService.h"

@interface YBViewController ()

@end

@implementation YBViewController {
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addNotificationHandler];
    UITapGestureRecognizer *tabToDismissKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAllKeyboard)];
    [_yunbaScrollView addGestureRecognizer:tabToDismissKeyboard];
    _yunbaScrollView.scrollsToTop = NO;
    _demoScrollView.scrollsToTop = NO;
    _messageListScrollView.scrollsToTop = YES;
    
    CGRect subViewRect = _demoScrollView.bounds;
    subViewRect.size.width = [UIScreen mainScreen].bounds.size.width;
    int i = 0;
    for (UIView * subView in
         @[_pubSubView, _aliasView, _presenceView, _getsView, _pub2View, _getsV2View, _apnsView
           ]) {
        subViewRect.origin.x = i * subViewRect.size.width;
        [subView setFrame:subViewRect];
        [_demoScrollView addSubview:subView];
        i++;
    }
    [_demoScrollView setContentSize:CGSizeMake(i*subViewRect.size.width, subViewRect.size.height)];
    
    [self initApnsStatus];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- yunba notifications
- (void)addNotificationHandler {
    NSNotificationCenter *defaultNC = [NSNotificationCenter defaultCenter];
    [defaultNC addObserver:self selector:@selector(onConnectionStateChanged:) name:kYBConnectionStatusChangedNotification object:nil];
    [defaultNC addObserver:self selector:@selector(onMessageReceived:) name:kYBDidReceiveMessageNotification object:nil];
    [defaultNC addObserver:self selector:@selector(onPresenceReceived:) name:kYBDidReceivePresenceNotification object:nil];
}

- (void)removeNotificationHandler {
    NSNotificationCenter *defaultNC = [NSNotificationCenter defaultCenter];
    [defaultNC removeObserver:self];
}

- (void)onConnectionStateChanged:(NSNotification *)notification {
    if ([YunBaService isConnected]) {
        NSLog(@"didConnect");
        NSString *prompt = [NSString stringWithFormat:@"[YunBaService] => didConnect"];
        [self addMsgToTextView:prompt alert:YES];
        _statusLabel.text = @"connected";
    } else {
        NSLog(@"didDisconnected");
        NSString *disconnectPrompt = [[notification object] objectForKey:kYBDisconnectPromptKey];
        NSString *prompt = [NSString stringWithFormat:@"[YunBaService] => disconnected [%@]", disconnectPrompt];
        [self addMsgToTextView:prompt alert:YES];
        _statusLabel.text = @"disconnected";
    }
}

- (void)onMessageReceived:(NSNotification *)notification {
    YBMessage *message = [notification object];
    NSLog(@"new message, %zu bytes, topic=%@", (unsigned long)[[message data] length], [message topic]);
    NSString *payloadString = [[NSString alloc] initWithData:[message data] encoding:NSUTF8StringEncoding];
    NSLog(@"data: %@ %@", payloadString,[message data]);
    NSString *curMsg = [NSString stringWithFormat:@"[Message] %@ => %@", [message topic], payloadString];
    [self addMsgToTextView:curMsg];
}

- (void)onPresenceReceived:(NSNotification *)notification {
    YBPresenceEvent *presence = [notification object];
    NSLog(@"new presence, action=%@, topic=%@, alias=%@, time=%lf", [presence action], [presence topic], [presence alias], [presence time]);
        
    NSString *curMsg = [NSString stringWithFormat:@"[Presence] %@:%@ => %@[%@]", [presence topic], [presence alias], [presence action], [NSDateFormatter localizedStringFromDate:[NSDate dateWithTimeIntervalSince1970:[presence time]/1000] dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle]];
    [self addMsgToTextView:curMsg];
}

#pragma mark - common ui apis
- (void)hideAllKeyboard {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (void)addMsgToTextView:(NSString *)message {
    [self addMsgToTextView:message alert:NO];
}
- (void)addMsgToTextView:(NSString *)message alert:(BOOL)alert {
    UILabel *newMessageLabel = [[UILabel alloc] initWithFrame:_messageListScrollView.bounds];
    newMessageLabel.numberOfLines = 12;
    newMessageLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    newMessageLabel.font = [UIFont systemFontOfSize:10.f];
    newMessageLabel.text = message;
    if (alert) {
        newMessageLabel.textColor = [UIColor redColor];
    }
    [newMessageLabel sizeToFit];
    
    //already scrolled to bottom
    BOOL shouldScrollToBottom = _messageListScrollView.contentOffset.y + _messageListScrollView.bounds.size.height >= _messageListScrollView.contentSize.height ? YES:NO;
    
#define SPACE_BETWEEN_MESSAGE_LABEL (2)
    float offset = _messageListScrollView.contentSize.height;
    if (offset > .1f) {
        offset += SPACE_BETWEEN_MESSAGE_LABEL;
    }
    newMessageLabel.frame = CGRectMake(0, offset, _messageListScrollView.bounds.size.width, newMessageLabel.bounds.size.height);
    [_messageListScrollView addSubview:newMessageLabel];
    _messageListScrollView.contentSize = CGSizeMake(_messageListScrollView.contentSize.width, newMessageLabel.frame.origin.y + newMessageLabel.bounds.size.height);
    
    if (shouldScrollToBottom) {
        float newOffset = _messageListScrollView.contentSize.height-_messageListScrollView.bounds.size.height;
        [_messageListScrollView setContentOffset:CGPointMake(0, newOffset > 0 ? newOffset:0) animated:NO];
    }
}

- (void)alertWithContent:(NSString *)contet {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"yunba-demo" message:contet delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alertView show];
}

#pragma mark -- keyboard appear/disappear
- (void)keyboardFrameChanged:(NSNotification *)notification {
    NSValue *rectValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    if (rectValue) {
        CGRect scrollRect = [_yunbaScrollView frame];
        CGRect keyboardRect = [rectValue CGRectValue];
        CGRect keyboardRectInView = [self.view convertRect:keyboardRect fromView:nil];
        CGFloat upScrollHeight = scrollRect.origin.y + scrollRect.size.height - keyboardRectInView.origin.y;
        
        // anination args
        NSNumber *numDuration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *numCurve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        
        // animate to scroll up
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:[numDuration doubleValue]];
        [UIView setAnimationCurve:[numCurve unsignedIntegerValue]];
        if (upScrollHeight > 0.f) {
            [_yunbaScrollView setContentOffset:CGPointMake(0, upScrollHeight)];
        } else {
            [_yunbaScrollView setContentOffset:CGPointZero];
        }
        [UIView commitAnimations];
    }
}
@end