//
//  PCSideMenuTransitionDelegate.h
//  Pods
//
//  Created by Ryan Fitzgerald on 8/10/16.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PCSideMenuPosition) {
  PCSideMenuPositionLeft,
  PCSideMenuPositionRight
};

@interface PCSideMenuTransitionDelegate : NSObject <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactionController;

-(instancetype)initWithMenuPosition:(PCSideMenuPosition)menuPosition;

@end

@interface PCSideMenuAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

@end
