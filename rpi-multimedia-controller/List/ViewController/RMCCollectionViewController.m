//
//  RMCCollectionViewController.m
//  rpi-multimedia-controller
//
//  Created by Zoltan Meszaros on 2020. 02. 10..
//  Copyright © 2020. private. All rights reserved.
//

#import "RMCCollectionViewController.h"
#import "RMCCommunicationController.h"
#import "RMCCollection.h"
#import "RMCSupport.h"

@implementation RMCCollectionViewCell
@end

@interface RMCCollectionViewController ()
@end

@implementation RMCCollectionViewController {
    UIBarButtonItem *_playingButton;
    UIBarButtonItem *_disconnectButton;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _collection = [RMCCollection new];
        [self registerNotifications];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBarButtons];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kCommunicationControllerRequestListNotification   object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:kCommunicationControllerRequestStatusNotification object:self];
}

- (void)setupBarButtons {
    _playingButton    = [[UIBarButtonItem alloc] initWithTitle:@"Playing"    style:UIBarButtonItemStylePlain target:self action:@selector(playingAction:   )];
    _disconnectButton = [[UIBarButtonItem alloc] initWithTitle:@"Disconnect" style:UIBarButtonItemStylePlain target:self action:@selector(disconnectAction:)];

    self.navigationItem.rightBarButtonItem = _playingButton;
    self.navigationItem.leftBarButtonItem  = _disconnectButton;
    
    _playingButton.enabled = NO;
}

- (void)playingAction:(id)sender {
    
}

- (void)disconnectAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kCommunicationControllerDisconnectNotification object:self];
}

- (void)didDisconnect:(NSNotification*)notification {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [self deregisterNotifications];
}

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDisconnect: ) name:kCommunicationControllerDidDisconnectNotification    object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveData:) name:kCommunicationControllerDidReceiveListNotification   object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveData:) name:kCommunicationControllerDidReceiveImageNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveData:) name:kCommunicationControllerDidReceiveStatusNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveData:) name:kCommunicationControllerDidReceiveErrorNotification  object:nil];
}

- (void)deregisterNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCommunicationControllerDidDisconnectNotification    object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCommunicationControllerDidReceiveListNotification   object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCommunicationControllerDidReceiveImageNotification  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCommunicationControllerDidReceiveStatusNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCommunicationControllerDidReceiveErrorNotification  object:nil];
}

#pragma mark - Data
- (void)didReceiveData:(NSNotification*)notification {
    id object = notification.userInfo[@"object"];
    if (object) {
        /**/ if ([notification.name isEqualToString:kCommunicationControllerDidReceiveListNotification  ]) { [self didReceiveList  :object]; }
        else if ([notification.name isEqualToString:kCommunicationControllerDidReceiveImageNotification ]) { [self didReceiveImage :object]; }
        else if ([notification.name isEqualToString:kCommunicationControllerDidReceiveStatusNotification]) { [self didReceiveStatus:object]; }
        else if ([notification.name isEqualToString:kCommunicationControllerDidReceiveErrorNotification ]) { [self didReceiveError :object]; }
    }
}

- (void)didReceiveError:(RMCError *)error {
    if ([error isKindOfClass:RMCError.class] && error.message && error.message.length > 0) {
        [RMCSupport showWarning:error.message inViewController:self];
    }
}

- (void)didReceiveList:(RMCList*)list {
    if ([list isKindOfClass:RMCList.class]) {
        /* store list */
        [_collection setItemsMerged:[RMCCollection itemsFromList:list.list]];
        
        /* reload collection */
        [self.collectionView reloadData];
        
        /* request missing images */
        for (RMCImage *item in _collection.items) {
            if (!item.image) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kCommunicationControllerRequestImageNotification object:self userInfo:@{ @"object" : item }];
            }
        }
    }
}

- (void)didReceiveImage:(RMCImage *)image {
    if ([image isKindOfClass:RMCImage.class]) {
        /* update image */
        [_collection updateItem:image];
        
        /* reload collection */
        [self.collectionView reloadData];
    }
}

- (void)didReceiveStatus:(RMCStatus*)status {
    _playingButton.enabled = [status isKindOfClass:RMCStatus.class] && status.act && status.act.length > 0;
}

#pragma mark - Collection View Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _collection.items.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    RMCImage *item = [_collection.items objectAtIndex:indexPath.item];
    RMCCollectionViewCell *obj = (RMCCollectionViewCell*)cell;
    obj.imageView.image = item.image;
    obj.title.text      = item.identifier.lastPathComponent;
}

@end
