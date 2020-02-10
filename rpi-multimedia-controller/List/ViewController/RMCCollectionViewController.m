//
//  RMCCollectionViewController.m
//  rpi-multimedia-controller
//
//  Created by Zoltan Meszaros on 2020. 02. 10..
//  Copyright © 2020. private. All rights reserved.
//

#import "RMCCollectionViewController.h"
#import "RMCCommunication.h"
#import "RMCCollection.h"

@implementation RMCCollectionViewCell
@end

@interface RMCCollectionViewController ()
@end

@implementation RMCCollectionViewController {
    RMCCommunication        *_communication;
    RMCCommunicationHandler *_handler;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (void)initialize {
    _handler       = [RMCCommunicationHandler new];
    _communication = [RMCCommunication        new];
    _collection    = [RMCCollection           new];
    
    _handler      .interface = _communication;
    _handler      .delegate  = self;
    _communication.delegate = _handler;
    
    [_communication connectToHost:@"192.168.0.199" onPort:61486 error:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Communication Handler Delegate
- (void)handler:(RMCCommunicationHandler*)handler didReceiveError :(RMCError *)error {
    
}

- (void)handler:(RMCCommunicationHandler*)handler didReceiveList  :(RMCList  *)list {
    NSArray *items = _collection.items;
    _collection.items = [RMCCollection itemsFromList:list.list];
    [_collection mergeWithItems:items];
    
    [self.collectionView reloadData];
    
    for (RMCImage *item in _collection.items) {
        if (!item.image) {
            [handler requestImage:item];
        }
    }
}

- (void)handler:(RMCCommunicationHandler*)handler didReceiveImage :(RMCImage *)image {
    [_collection updateItem:image];
    [self.collectionView reloadData];
}

- (void)handler:(RMCCommunicationHandler*)handler didReceiveStatus:(RMCStatus*)status {
    
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
