//
//  RMCCollectionViewController.m
//  rpi-multimedia-controller
//
//  Created by Zoltan Meszaros on 2020. 02. 10..
//  Copyright © 2020. private. All rights reserved.
//

#import "PureLayout.h"
#import "RMCCollectionViewController.h"
#import "RMCCommunicationController.h"
#import "RMCListProxy.h"
#import "RMCCollection.h"
#import "RMCSupport.h"

@implementation RMCCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        [self.contentView addSubview:_titleLabel];
        [_titleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 5, 0, 5) excludingEdge:ALEdgeTop];
        [_titleLabel autoSetDimension:ALDimensionHeight toSize:30];
        
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imageView];
        [_imageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(5, 5, 0, 5) excludingEdge:ALEdgeBottom];
        [_imageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_titleLabel];
        
        _imageView.clipsToBounds = YES;
        _imageView.layer.cornerRadius = 10;
        self      .layer.cornerRadius = 10;
    }
    
    return self;
}

@end

@implementation RMCCollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        _searchBar = [UISearchBar new];
        [self addSubview:_searchBar];
        [_searchBar autoPinEdgesToSuperviewEdges];
    }
    
    return self;
}

@end

#import "UIBar+Separator.h"
#import "UIImage+Color.h"

@interface RMCCollectionViewController () <UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@end

@implementation RMCCollectionViewController {
    RMCListProxy    *_proxy;
    RMCStatus       *_status;
    
    UISearchBar      *_searchBar;
    UICollectionView *_collectionView;
    
    UIBarButtonItem  *_playingButton;
    UIBarButtonItem  *_disconnectButton;
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
    
    [self setupUI   ];
    [self setupProxy];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kCommunicationControllerRequestListNotification   object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:kCommunicationControllerRequestStatusNotification object:self];
}

- (void)setupUI {
    [self setupMain          ];
    [self setupCollectionView];
    [self setupSearchBar     ];
    [self setupBarButtons    ];
}

- (void)playingAction:(id)sender {
    /* ... - push playing VC */
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
    id object = notification.userInfo[kUserInfoObjectKey];
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
        _proxy.model = _collection.items;
        
        /* request missing images */
        for (RMCImage *item in _collection.items) {
            if (!item.image) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kCommunicationControllerRequestImageNotification object:self userInfo:@{ kUserInfoObjectKey : item }];
            }
        }
    }
}

- (void)didReceiveImage:(RMCImage *)image {
    if ([image isKindOfClass:RMCImage.class]) {
        /* update image */
        [_collection updateItem:image];
        
        /* reload collection */
        [_proxy invalidate];
    }
}

- (void)didReceiveStatus:(RMCStatus*)status {
    _status = [status isKindOfClass:RMCStatus.class] && status.act && status.act.length > 0 ? status : nil;
    _playingButton.enabled = _status != nil;
}

#pragma mark - Collection View Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _proxy.filteredModel.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    RMCImage *item = _proxy.filteredModel[indexPath.item];
    RMCCollectionViewCell *obj = (RMCCollectionViewCell*)cell;
    obj.imageView.backgroundColor = item.image ? [UIColor clearColor] : [[UIColor blackColor] colorWithAlphaComponent:0.05];
    obj.imageView.image = item.image;
    obj.titleLabel.text = item.identifier.lastPathComponent;
    
    BOOL isPlaying = _status && [item.identifier isEqualToString:_status.act];
    obj.layer.borderWidth = isPlaying ? 2                          : 0;
    obj.layer.borderColor = isPlaying ? [UIColor redColor].CGColor : [UIColor clearColor].CGColor;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    /* ... */
}

#pragma mark - Flow Layout Delegate
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return RMCConstants.collectionCellDistance;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return RMCConstants.collectionCellDistance;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    CGFloat inset = [self collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:0];
    return UIEdgeInsetsMake(inset, inset, 0, inset);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return RMCConstants.collectionCellSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.frame.size.width, 50.f);
}

#pragma mark - Search Bar Delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([_proxy respondsToSelector:@selector(setFilter:)]) {
        [_proxy performSelector:@selector(setFilter:) withObject:searchText];
    }
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - local initialization
- (void)setupMain {
    self.navigationController.navigationBar.separatorView.hidden = YES;
    self.navigationController.navigationBar.translucent = NO;
}

- (void)setupCollectionView {
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate   = self;
    _collectionView.dataSource = self;
    _collectionView.alwaysBounceVertical = YES;
    [_collectionView registerClass:RMCCollectionViewCell.class forCellWithReuseIdentifier:@"Cell"];
    
    [self.view addSubview:_collectionView];
    [_collectionView autoPinEdgesToSuperviewEdges];
}

- (void)setupSearchBar {
    _searchBar = [UISearchBar new];
    _searchBar.delegate     = self;
    _searchBar.placeholder  = @"Filter media";
    _searchBar.backgroundImage = [UIImage imageFromColor:[UISearchBar appearance].barTintColor];
    
    [self.view addSubview:_searchBar];
    [_searchBar autoPinToTopLayoutGuideOfViewController:self withInset:0];
    [_searchBar autoPinEdgeToSuperviewEdge:ALEdgeLeading ];
    [_searchBar autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [_searchBar autoSetDimension:ALDimensionHeight toSize:45];
    
    [_searchBar sizeToFit];
}

- (void)setupBarButtons {
    _playingButton    = [[UIBarButtonItem alloc] initWithTitle:@"Playing"    style:UIBarButtonItemStylePlain target:self action:@selector(playingAction:   )];
    _disconnectButton = [[UIBarButtonItem alloc] initWithTitle:@"Disconnect" style:UIBarButtonItemStylePlain target:self action:@selector(disconnectAction:)];

    self.navigationItem.rightBarButtonItem = _playingButton;
    self.navigationItem.leftBarButtonItem  = _disconnectButton;
    
    _playingButton.enabled = NO;
}

- (void)setupProxy {
    _proxy = [[RMCListProxy alloc] initWithModel:self.collection.items
                                         andView:_collectionView];
}

@end
