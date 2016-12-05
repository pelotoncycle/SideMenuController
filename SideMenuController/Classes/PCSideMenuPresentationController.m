//
//  PCSideMenuPresentationController.m
//  Pods
//
//  Created by Ryan Fitzgerald on 8/10/16.
//
//

#import "PCSideMenuPresentationController.h"
//#import "UIApplication+Utility.h"
#import "PCSideMenuTransitionDelegate.h"
//#import "UIViewController+Helper.h"

@interface PCSideMenuPresentationController ()

@property (nonatomic, strong) UIView *dimmingView;

@end

@implementation PCSideMenuPresentationController

- (void)dealloc {
  for (UIGestureRecognizer *gestureRecognizer in [self.containerView.gestureRecognizers copy]) {
    [self.containerView removeGestureRecognizer:gestureRecognizer];
  }

  for (UIGestureRecognizer *gestureRecognizer in [self.dimmingView.gestureRecognizers copy]) {
    [self.dimmingView removeGestureRecognizer:gestureRecognizer];
  }
}

#pragma mark - Lazy Instantiation

-(void)setBackdropColor:(UIColor *)backdropColor {
  _backdropColor = backdropColor;
  
}

-(UIView *)dimmingView {
  if (_dimmingView == nil) {
    _dimmingView = [UIView new];
    if (self.backdropColor != nil) {
      _dimmingView.backgroundColor = self.backdropColor;
    } else {
      _dimmingView.backgroundColor = [UIColor colorWithRed:13.0/255.0 green:13.0/255.0 blue:13.0/255.0 alpha:0.6];
    }
    _dimmingView.userInteractionEnabled = YES;
    _dimmingView.alpha = 0.0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapBackground:)];
    tap.numberOfTapsRequired = 1;
    [_dimmingView addGestureRecognizer:tap];
  }

  return _dimmingView;
}

-(void)presentationTransitionWillBegin {

  self.dimmingView.frame = self.containerView.bounds;

  [self.containerView addSubview:self.dimmingView];
  [self.containerView addSubview:self.presentedView];

  UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDismissalPan:)];
  [self.containerView addGestureRecognizer:pan];
  self.containerView.userInteractionEnabled = YES;

  [self.presentingViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
    self.dimmingView.alpha = 1.0;
    [self setStatusBarHidden:YES animated:NO];
  } completion:nil];
}

-(void)dismissalTransitionWillBegin {
  [self.presentingViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
    if (!context.isInteractive) {
      [self setStatusBarHidden:NO animated:NO];
    }
    self.dimmingView.alpha = 0;
  } completion:nil];
}

-(void)presentationTransitionDidEnd:(BOOL)completed {
  if (!completed) {
    [self.dimmingView removeFromSuperview];
    [self setStatusBarHidden:NO animated:NO];
  }
}

- (CGFloat)menuWidth {
  CGFloat width = 225;

  if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular) {
    width = 300;
  }

  return width;
}

-(CGRect)frameOfPresentedViewInContainerView {
  CGRect bounds = self.containerView.bounds;
  CGFloat x;

  if (self.menuPosition == PCSideMenuPositionLeft) {
    x = bounds.origin.x;
  } else {
    x = CGRectGetWidth(bounds) - [self menuWidth];
  }

  return CGRectMake(x, bounds.origin.y, [self menuWidth], bounds.size.height);
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {

  [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
    self.dimmingView.frame = self.containerView.bounds;
  } completion:nil];
}

- (void)didTapBackground:(UITapGestureRecognizer *)sender {
  [self transitionDelegate].interactionController = nil;
  [self.presentingViewController dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - Gesture
- (void)handleDismissalPan:(UIPanGestureRecognizer *)panGesture {
  switch (panGesture.state) {
    case UIGestureRecognizerStatePossible:
      break;//Do nothing
    case UIGestureRecognizerStateBegan:
      [self handlePanStarted:panGesture];
      break;
    case UIGestureRecognizerStateChanged:
      [self handlePanChanged:panGesture];
      break;
    case UIGestureRecognizerStateEnded:
      [self handlePanEnded:panGesture];
      break;
    case UIGestureRecognizerStateFailed: //Intentional Fallthrough
    case UIGestureRecognizerStateCancelled:
      [self handlePanFailiure:panGesture];
      break;
  }
}

- (void)handlePanStarted:(UIPanGestureRecognizer *)panGesture {
  [self transitionDelegate].interactionController = [[UIPercentDrivenInteractiveTransition alloc ]init];
  [panGesture setTranslation:CGPointZero inView:panGesture.view];

  [self.presentingViewController dismissViewControllerAnimated:true completion:nil];
}

- (void)handlePanChanged:(UIPanGestureRecognizer *)panGesture {
  const CGFloat translation = [panGesture translationInView:self.containerView].x;
  const CGFloat percent = fabs(translation / [self menuWidth]);

  if (self.menuPosition == PCSideMenuPositionLeft && translation <= 0.0) {
    [[self transitionDelegate].interactionController updateInteractiveTransition:MIN(percent, 1.0)];
  } else if (self.menuPosition == PCSideMenuPositionRight && translation >= 0.0) {
    [[self transitionDelegate].interactionController updateInteractiveTransition:MIN(percent, 1.0)];
  }
}

- (void)handlePanEnded:(UIPanGestureRecognizer *)panGesture {
  CGFloat percentComplete  = [[self transitionDelegate].interactionController percentComplete];
  CGFloat threshold = 0.5;
  if (percentComplete > threshold) {
    [self setStatusBarHidden:NO animated:YES];
    [self transitionDelegate].interactionController.completionSpeed = 0.3;
    [[self transitionDelegate].interactionController finishInteractiveTransition];
  } else {
    [self transitionDelegate].interactionController.completionSpeed = 0.5;
    [[self transitionDelegate].interactionController cancelInteractiveTransition];
  }

  [self transitionDelegate].interactionController = nil;
}

- (void)handlePanFailiure:(UIPanGestureRecognizer *)panGesture {
  [[self transitionDelegate].interactionController cancelInteractiveTransition];
  [self transitionDelegate].interactionController = nil;
}

-(PCSideMenuTransitionDelegate *)transitionDelegate {
  return self.presentedViewController.transitioningDelegate;
}

- (void)setStatusBarHidden:(BOOL) hidden animated:(BOOL)animated {
  UIView *statusbar = [self statusBarView];

  if (statusbar == nil) {
    return;
  }

  CGAffineTransform transform;

  if (hidden) {
    transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(statusbar.bounds));
  } else {
    transform = CGAffineTransformIdentity;
  }

  if (animated) {
    [UIView animateWithDuration:0.2
                          delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                       statusbar.transform = transform;
                     } completion:nil];
  } else {
    statusbar.transform = transform;
  }

}

- (UIView *)statusBarView {
  UIApplication *app = [UIApplication sharedApplication];
  NSString *key = [[NSString alloc] initWithData:[NSData dataWithBytes:(unsigned char []){0x73, 0x74, 0x61, 0x74, 0x75, 0x73, 0x42, 0x61, 0x72} length:9] encoding:NSASCIIStringEncoding];
  UIView *statusBar = nil;
  if ([app respondsToSelector:NSSelectorFromString(key)]) {
    statusBar = [app valueForKey:key];
  }
  return statusBar;
}
@end
