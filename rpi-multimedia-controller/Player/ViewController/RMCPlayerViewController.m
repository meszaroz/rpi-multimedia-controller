//
//  RMCPlayerViewController.m
//  rpi-multimedia-controller
//
//  Created by Zoltan Meszaros on 2020. 02. 11..
//  Copyright © 2020. private. All rights reserved.
//

#import <MobileVLCKit/MobileVLCKit.h>
#import "RMCPlayerViewController.h"
#import "RMCCommunicationController.h"
#import "RMCStatus.h"

static const uint16_t   kStreamPort       = 8554;
static NSString * const kStreamIdentifier = @"stream";

static NSString *streamURLString() {
    return [NSString stringWithFormat: @"rtsp://%@:%d/%@", [RMCCommunicationController defaultController].host, kStreamPort, kStreamIdentifier];
}

@interface RMCPlayerViewController () <VLCMediaPlayerDelegate>
@end

@implementation RMCPlayerViewController {
    VLCMediaPlayer *_mediaPlayer;
    RMCStatus      *_status;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _status = nil;
        [self registerNotifications];
    }
    
    return self;
}

- (void)loadView {
    _movieView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _movieView.backgroundColor = [UIColor redColor];
    self.view = _movieView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* setup the media player instance, give it a delegate and something to draw into */
    _mediaPlayer = [VLCMediaPlayer new];
    _mediaPlayer.delegate = self;
    _mediaPlayer.drawable = self.movieView;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kCommunicationControllerRequestStatusNotification object:self];
}

- (void)didDisconnect:(NSNotification*)notification {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)dealloc {
    [self deregisterNotifications];
}

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDisconnect:   ) name:kCommunicationControllerDidDisconnectNotification    object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveStatus:) name:kCommunicationControllerDidReceiveStatusNotification object:nil];
}

- (void)deregisterNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCommunicationControllerDidDisconnectNotification    object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCommunicationControllerDidReceiveStatusNotification object:nil];
}

#pragma mark - Data
- (void)didReceiveStatus:(NSNotification*)notification {
    RMCStatus *status = _status;
    RMCStatus *obj    = notification.userInfo[kUserInfoObjectKey];
    
    _status = obj && obj.isValid ? obj : nil;
    
    /* stop playing if error */
    if (!_status) {
        [_mediaPlayer stop];
        _mediaPlayer.media = nil;
    }
    
    /* set media if not available yet */
    if ((!status && _status)
     || (![status.act isEqualToString:_status.act])) {
        [_mediaPlayer stop];
        _mediaPlayer.media = [VLCMedia mediaWithURL:[NSURL URLWithString:streamURLString()]];
    }
    
    /* set status */
    if (_status && _status.isValid && _mediaPlayer.media) {
        [_mediaPlayer performSelector:@selector(play) withObject:nil afterDelay:1];
    }
}

- (void)mediaPlayerStateChanged:(NSNotification *)aNotification {
    VLCMediaPlayer *player = aNotification.object;
    if (player.state == VLCMediaStatePlaying && _status) {
        
    }
}

@end
