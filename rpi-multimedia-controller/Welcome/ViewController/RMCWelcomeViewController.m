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

- (void)setupUI {
    _connectionView = [UIView new];
    _connectionView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.95];
    _connectionView.layer.cornerRadius = 5;
    _connectionView.clipsToBounds = YES;
    
    [self addSubview:_connectionView];
    [_connectionView autoPinEdgesToSuperviewEdges];
    
    _connectionTitleLabel = [UILabel new];
    _connectionTitleLabel.textAlignment   = NSTextAlignmentCenter;
    _connectionTitleLabel.textColor       = [UIColor darkGrayColor];
    _connectionTitleLabel.backgroundColor = [UIColor clearColor];
    
    [_connectionView addSubview:_connectionTitleLabel];
    [_connectionTitleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10, 0, 0, 0) excludingEdge:ALEdgeBottom];
    [_connectionTitleLabel autoSetDimension:ALDimensionHeight toSize:20];
    
    _serverInput = [RMCWelcomeInputView new];
    _serverInput.tintColor = [UIColor grayColor];
    _serverInput.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _serverInput.textField.placeholder = @"Host";
    [_connectionView addSubview:_serverInput];
    [_serverInput autoPinEdgeToSuperviewEdge:ALEdgeLeft  withInset:10];
    [_serverInput autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [_serverInput autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_connectionTitleLabel withOffset:10];
    [_serverInput autoSetDimension:ALDimensionHeight toSize:30];
    
    _portInput = [RMCWelcomeInputView new];
    _portInput.tintColor = [UIColor grayColor];
    _portInput.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _portInput.textField.placeholder = @"Port";
    [_connectionView addSubview:_portInput];
    [_portInput autoPinEdgeToSuperviewEdge:ALEdgeLeft   withInset:10];
    [_portInput autoPinEdgeToSuperviewEdge:ALEdgeRight  withInset:10];
    [_portInput autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:20];
    [_portInput autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_serverInput withOffset:10];
    [_portInput autoSetDimension:ALDimensionHeight toSize:30];
}

@end

@implementation RMCWelcomeServerSelectorView(Empty)

- (BOOL)allFieldsEmpty {
    return _serverInput.textField.text.length == 0
          && _portInput.textField.text.length == 0;
}

@end

#import "MZActivityIndicatorOverlayView.h"

@interface RMCWelcomeViewController ()

@end

@implementation RMCWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self activateUI];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setupUI {
    [self setupMain    ];
    [self setupButton  ];
    [self setupActivity];
    [self setupSelector];
    [self setupLogo    ];
}

- (void)activateUI {
    [self.view addSubview:_serverSelectorView];
    [self.view addSubview:_startButton];
    
    [_serverSelectorView autoSetDimension:ALDimensionWidth toSize:280];
    [_serverSelectorView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_serverSelectorView autoAlignAxisToSuperviewAxis:ALAxisHorizontal].constant = -50;
    
    [_startButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_startButton autoSetDimensionsToSize:CGSizeMake(280, 45)];
    [_startButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:40];
    
    [self.view addSubview:_activityView];
    [_activityView autoPinEdgesToSuperviewEdges];
}

#pragma mark - local initialization
- (void)setupMain {
}

- (void)setupButton {
    _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_startButton addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
    
    _startButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    [_startButton setTitle:@"CONNECT"                    forState:UIControlStateNormal     ];
    [_startButton setTitleColor:[UIColor whiteColor]     forState:UIControlStateNormal     ];
    [_startButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    _startButton.backgroundColor = [UIColor redColor];
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
