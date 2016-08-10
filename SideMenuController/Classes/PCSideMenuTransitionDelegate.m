//
//  PCSideMenuTransitionDelegate.m
//  Pods
//
//  Created by Ryan Fitzgerald on 8/10/16.
//
//


#import "PCSideMenuTransitionDelegate.h"
#import "PCSideMenuPresentationController.h"

@interface PCSideMenuAnimationController ()

@property (nonatomic) BOOL isPresenting;
@property (nonatomic) PCSideMenuPosition menuPosition;

@end

@implementation PCSideMenuAnimationController

- (id)initWithIsPresenting:(BOOL)isPresenting menuPosition:(PCSideMenuPosition)menuPosition {
  self = [super init];
  if(self) {
    self.isPresenting = isPresenting;
    self.menuPosition = menuPosition;
  }

  return self;
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 0.2;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  if(self.isPresenting) {
    [self animatePresentationWithTransitionContext:transitionContext];
  } else {
    [self animateDismissalWithTransitionContext:transitionContext];
  }
}

#pragma mark - helpers

-(void)animatePresentationWithTransitionContext:(id<UIViewControllerContextTransitioning>)context {
  UIView *toView = [context viewForKey:UITransitionContextToViewKey];
  UIView *containerView = [context containerView];

  CGRect finalFrame = [self finalFrameForContext:context];

  toView.frame = [self startFrameForContext:context];

  [containerView addSubview:toView];

  [UIView animateWithDuration:[self transitionDuration:context]
                        delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
                     toView.frame = finalFrame;
                   } completion:^(BOOL finished) {
                     [context completeTransition:finished];
                   }];
}

- (CGRect)startFrameForContext:(id<UIViewControllerContextTransitioning>)context {
  UIViewController *toVC = [context viewControllerForKey:UITransitionContextToViewControllerKey];
  CGRect finalFrame = [context finalFrameForViewController:toVC];

  CGFloat width = CGRectGetWidth(finalFrame);
  CGFloat x;

  if (self.menuPosition == PCSideMenuPositionLeft) {
    x = -width;
  } else {
    UIView *containerView = [context containerView];
    x = CGRectGetWidth(containerView.bounds);
  }

  return CGRectMake(x, 0, width, CGRectGetHeight(finalFrame));
}

- (CGRect)finalFrameForContext:(id<UIViewControllerContextTransitioning>)context {
  UIViewController *toVC = [context viewControllerForKey:UITransitionContextToViewControllerKey];

  return [context finalFrameForViewController:toVC];
}

-(void)animateDismissalWithTransitionContext:(id<UIViewControllerContextTransitioning>)context {
  UIViewController *fromVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIView *containerView = [context containerView];

  CGRect frame = fromVC.view.bounds;
  CGFloat x;

  if (self.menuPosition == PCSideMenuPositionLeft) {
    x = containerView.bounds.origin.x - frame.size.width;
  } else {
    x = containerView.bounds.size.width;
  }

  [UIView animateWithDuration:[self transitionDuration:context]
                        delay:0 options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
                     fromVC.view.frame = CGRectMake(x, frame.origin.y, frame.size.width, frame.size.height);
                   } completion:^(BOOL finished) {
                     [context completeTransition:![context transitionWasCancelled]];
                   }];
}

@end

@interface PCSideMenuTransitionDelegate ()

@property (nonatomic) PCSideMenuPosition menuPosition;

@end

@implementation PCSideMenuTransitionDelegate

-(instancetype)init {
  return [self initWithMenuPosition:PCSideMenuPositionLeft];
}

-(instancetype)initWithMenuPosition:(PCSideMenuPosition)menuPosition {
  self = [super init];
  if (self) {
    self.menuPosition = menuPosition;
  }

  return self;
}

-(UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented
                                                     presentingViewController:(UIViewController *)presenting
                                                         sourceViewController:(UIViewController *)source {
  PCSideMenuPresentationController *result = [[PCSideMenuPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
  result.menuPosition = self.menuPosition;

  return result;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                 presentingController:(UIViewController *)presenting
                                                                     sourceController:(UIViewController *)source {
  return [[PCSideMenuAnimationController alloc] initWithIsPresenting:true menuPosition:self.menuPosition];
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
  return [[PCSideMenuAnimationController alloc] initWithIsPresenting:false menuPosition:self.menuPosition];
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
  return self.interactionController;
}

@end
