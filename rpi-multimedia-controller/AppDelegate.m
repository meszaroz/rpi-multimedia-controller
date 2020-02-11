//
//  AppDelegate.m
//  rpi-multimedia-controller
//
//  Created by Zoltan Meszaros on 2020. 02. 10..
//  Copyright © 2020. private. All rights reserved.
//

#import "AppDelegate.h"
#import "RMCWelcomeViewController.h"
#import "RMCCommunicationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupCommunication];
    [self setupWindow       ];
    [self setupAppearance   ];
    return YES;
}

- (void)setupCommunication {
    [RMCCommunicationController defaultController];
}

- (void)setupWindow {
    UIViewController *rootVC = [RMCWelcomeViewController new];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:rootVC];
    navVC.view.backgroundColor = [UIColor whiteColor];
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = navVC;
    [self.window makeKeyAndVisible];
}

- (void)setupAppearance {
    [UINavigationBar appearance].titleTextAttributes = @{ NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:20.0f] };
    [UINavigationBar appearance].tintColor       = [UIColor whiteColor];
    [UINavigationBar appearance].barTintColor    = [UIColor systemOrangeColor];
    [UIButton        appearance].backgroundColor = [UIColor systemOrangeColor];
    [UISearchBar     appearance].barTintColor    = [UIColor systemOrangeColor];
    [UISearchBar     appearance].tintColor       = [UIColor whiteColor];
}

#pragma mark - UISceneSession lifecycle


@end
