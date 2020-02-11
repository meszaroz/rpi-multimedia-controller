//
//  RMCWelcomeViewController.m
//  rpi-multimedia-controller
//
//  Created by Zoltan Meszaros on 2020. 02. 10..
//  Copyright © 2020. private. All rights reserved.
//

#import "PureLayout.h"
#import "RMCWelcomeViewController.h"
#import "RMCWelcomeInputView.h"

@implementation RMCWelcomeServerSelectorView {
    UIView  *_connectionView;
    UILabel *_connectionTitleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupUI];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    
    if (self) {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    _connectionView = [UIView new];
    _connectionView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.05];
    _connectionView.layer.cornerRadius = 5;
    _connectionView.clipsToBounds = YES;
    
    [self addSubview:_connectionView];
    [_connectionView autoPinEdgesToSuperviewEdges];
    
    _connectionTitleLabel = [UILabel new];
    _connectionTitleLabel.text = @"Connect to server";
    _connectionTitleLabel.textAlignment   = NSTextAlignmentCenter;
    _connectionTitleLabel.textColor       = [UIColor darkGrayColor];
    _connectionTitleLabel.backgroundColor = [UIColor clearColor];
    
    [_connectionView addSubview:_connectionTitleLabel];
    [_connectionTitleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10, 0, 0, 0) excludingEdge:ALEdgeBottom];
    [_connectionTitleLabel autoSetDimension:ALDimensionHeight toSize:30];
    
    _hostInput = [RMCWelcomeInputView new];
    _hostInput.tintColor = [UIColor grayColor];
    _hostInput.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _hostInput.textField.placeholder = @"Host";
    [_connectionView addSubview:_hostInput];
    [_hostInput autoPinEdgeToSuperviewEdge:ALEdgeLeft  withInset:10];
    [_hostInput autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [_hostInput autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_connectionTitleLabel withOffset:10];
    [_hostInput autoSetDimension:ALDimensionHeight toSize:30];
    
    _portInput = [RMCWelcomeInputView new];
    _portInput.tintColor = [UIColor grayColor];
    _portInput.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _portInput.textField.placeholder = @"Port";
    [_connectionView addSubview:_portInput];
    [_portInput autoPinEdgeToSuperviewEdge:ALEdgeLeft   withInset:10];
    [_portInput autoPinEdgeToSuperviewEdge:ALEdgeRight  withInset:10];
    [_portInput autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:20];
    [_portInput autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_hostInput withOffset:10];
    [_portInput autoSetDimension:ALDimensionHeight toSize:30];
}

@end

@implementation RMCWelcomeServerSelectorView(Empty)

- (BOOL)allFieldsEmpty {
    return _hostInput.textField.text.length == 0
        && _portInput.textField.text.length == 0;
}

@end

#import "MZActivityIndicatorOverlayView.h"
#import "RMCCommunicationController.h"
#import "RMCCollectionViewController.h"
#import "RMCSupport.h"

@interface RMCWelcomeViewController ()
@end

@implementation RMCWelcomeViewController

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self registerNotifications];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Welcome";
    
    [self setupUI];
    [self activateUI];
    
    [self loadConnection];
}

- (void)setupUI {
    [self setupMain    ];
    [self setupButton  ];
    [self setupActivity];
    [self setupSelector];
    [self setupLogo    ];
}

- (void)activateUI {
    [self.view addSubview:_serverSelectorView];
    [self.view addSubview:_startButton       ];
    
    [_startButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_startButton autoSetDimensionsToSize:CGSizeMake(280, 45)];
    [_startButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:50];
    
    [_serverSelectorView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_serverSelectorView autoAlignAxisToSuperviewAxis:ALAxisHorizontal].constant = -50;
    [_serverSelectorView autoSetDimension:ALDimensionWidth toSize:280];
    
    [self.navigationController.view addSubview:_activityView];
    [_activityView autoPinEdgesToSuperviewEdges];
}

- (IBAction)connectAction:(id)sender {
    NSString *host = _serverSelectorView.hostInput.textField.text;
    NSString *port = _serverSelectorView.portInput.textField.text;
    
    if (host.length > 0 && port.length > 0 && port.intValue > 0) {
        __weak typeof(self) weakSelf = self;
        [_activityView setHidden:NO animated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kCommunicationControllerConnectNotification object:weakSelf userInfo:@{ kUserInfoHostKey : host, kUserInfoPortKey : @(port.intValue) }];
        }];
    }
    else {
        [RMCSupport showWarning:@"Wrong host and/or port settings" inViewController:self];
    }
}

- (void)didConnect:(NSNotification*)notification {
    __weak typeof(self) weakSelf = self;
    [_activityView setHidden:YES animated:YES completion:^{
        if (notification.userInfo) {
            NSError *error = notification.userInfo[kUserInfoErrorKey];
            if (error) {
                [RMCSupport showWarning:error.localizedDescription inViewController:weakSelf];
            }
            else {
                RMCCollectionViewController *collectionVC = [RMCCollectionViewController new];
                [weakSelf.navigationController pushViewController:collectionVC animated:YES];
                [weakSelf saveConnection];
            }
        }
    }];
}

- (void)dealloc {
    [self deregisterNotifications];
}

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didConnect:) name:kCommunicationControllerDidConnectNotification    object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didConnect:) name:kCommunicationControllerDidDisconnectNotification object:nil];
}

- (void)deregisterNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCommunicationControllerDidConnectNotification    object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCommunicationControllerDidDisconnectNotification object:nil];
}

#pragma mark - local initialization
- (void)setupMain {
}

- (void)setupButton {
    _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _startButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    [_startButton addTarget:self action:@selector(connectAction:) forControlEvents:UIControlEventTouchUpInside];
    [_startButton setTitle:@"Connect"                    forState:UIControlStateNormal     ];
    [_startButton setTitleColor:[UIColor whiteColor]     forState:UIControlStateNormal     ];
    [_startButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    _startButton.backgroundColor = [UIColor redColor];
    _startButton.layer.cornerRadius = 5;
    _startButton.clipsToBounds = YES;
}

- (void)setupSelector {
    _serverSelectorView = [RMCWelcomeServerSelectorView new];
}

- (void)setupActivity {
    _activityView = [MZActivityIndicatorOverlayView new];
}

- (void)setupLogo {
}

@end

static NSString * const kHostKey  = @"host";
static NSString * const kPostKey  = @"post";

@implementation RMCWelcomeViewController(Defaults)

- (void)saveConnection {
    NSString *tmpHost = _serverSelectorView.hostInput.textField.text;
    NSString *tmpPort = _serverSelectorView.portInput.textField.text;
    
    if (tmpHost && tmpHost.length   > 0
     && tmpPort && tmpPort.intValue > 0) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:tmpHost forKey:kHostKey];
        [defaults setObject:tmpPort forKey:kPostKey];
    }
}

- (void)loadConnection {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *tmpHost = [defaults objectForKey:kHostKey];
    NSString *tmpPort = [defaults objectForKey:kPostKey];
    
    if (tmpHost && tmpPort) {
        _serverSelectorView.hostInput.textField.text = tmpHost;
        _serverSelectorView.portInput.textField.text = tmpPort;
    }
}

@end
