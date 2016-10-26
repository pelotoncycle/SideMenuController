//
//  PCSideMenuPresentationController.h
//  Pods
//
//  Created by Ryan Fitzgerald on 8/10/16.
//
//

#import <UIKit/UIKit.h>
#import "PCSideMenuTransitionDelegate.h"

@interface PCSideMenuPresentationController : UIPresentationController

@property (nonatomic) PCSideMenuPosition menuPosition;
@property (nonatomic, strong) UIColor *backdropColor;

@end
