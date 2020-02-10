//
//  RMCSupport.m
//  rpi-multimedia-controller
//
//  Created by Zoltan Meszaros on 2020. 02. 10..
//  Copyright © 2020. private. All rights reserved.
//

#import "RMCSupport.h"

@implementation RMCSupport

+ (void)showWarning:(NSString*)message inViewController:(UIViewController*)vc {
    if (message && vc) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Warning" message:message preferredStyle:UIAlertControllerStyleAlert];
        [controller addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [vc presentViewController:controller animated:YES completion:nil];
    }
}

@end
