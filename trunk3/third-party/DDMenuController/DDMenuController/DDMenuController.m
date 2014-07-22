//
//  DDMenuController.m
//  DDMenuController
//
//  Created by Devin Doty on 11/30/11.
//  Copyright (c) 2011 toaast. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "DDMenuController.h"

#import <QuartzCore/QuartzCore.h>

#import <objc/runtime.h>

#define kMenuFullWidth 320.0f
#define kMenuDisplayedWidth 260.0f
#define kMenuOverlayWidth (self.view.bounds.size.width - kMenuDisplayedWidth)
#define kMenuBounceOffset 10.0f
#define kMenuBounceDuration .3f
#define kMenuSlideDuration .3f

static const char DDMenuControllerReferenceKey;

@implementation UIViewController (DDMenuController)

-(DDMenuController*)menuController
{
   DDMenuController* navigation_menu_controller_ = self.navigationController.menuController;
   if ( navigation_menu_controller_ )
      return navigation_menu_controller_;

   return objc_getAssociatedObject( self, &DDMenuControllerReferenceKey );
}

-(void)setMenuController:( DDMenuController* )menu_controller_
{
   objc_setAssociatedObject( self
                            , &DDMenuControllerReferenceKey
                            , menu_controller_
                            , OBJC_ASSOCIATION_ASSIGN );
}

@end

@interface UIViewController (AddViewController)

-(void)addController:( UIViewController* )controller_
            animated:( BOOL )animated_;

-(void)insertController:( UIViewController* )controller_
                atIndex:( NSUInteger )index_
                  frame:( CGRect )frame_
       autoresizingMask:( UIViewAutoresizing )mask_
               animated:( BOOL )animated_;

-(void)removeController:( UIViewController* )controller_
               animated:( BOOL )animated_;

@end

@implementation UIViewController (AddViewController)

-(BOOL)supportsChildrenControllers
{
   return [ UIViewController instancesRespondToSelector: @selector(removeFromParentViewController) ];
}

-(void)insertController:( UIViewController* )controller_
                atIndex:( NSUInteger )index_
                  frame:( CGRect )frame_
       autoresizingMask:( UIViewAutoresizing )mask_
               animated:( BOOL )animated_
{
   UIView* view_ = controller_.view;
   view_.autoresizingMask = mask_;
   view_.frame = frame_;

   if ( [ self supportsChildrenControllers ] )
   {
      [ self addChildViewController: controller_ ];
   }
   else
   {
      [ controller_ viewWillAppear: animated_ ];
   }

   [ self.view insertSubview: controller_.view atIndex: index_ ];

   if ( ![ self supportsChildrenControllers ] )
   {
      [ controller_ viewDidAppear: animated_ ];
   }
}

-(void)addController:( UIViewController* )controller_
            animated:( BOOL )animated_
{
   UIView* view_ = controller_.view;
   view_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   view_.frame = self.view.bounds;

   if ( [ self respondsToSelector: @selector(addChildViewController:) ] )
   {
      [ self addChildViewController: controller_ ];
   }
   else
   {
      [ controller_ viewWillAppear: animated_ ];
   }

   [ self.view addSubview: view_ ];

   if ( ![ self supportsChildrenControllers ] )
   {
      [ controller_ viewDidAppear: animated_ ];
   }
}

-(void)removeController:( UIViewController* )controller_
               animated:( BOOL )animated_
{
   if ( [ self supportsChildrenControllers ] )
   {
      [ controller_ removeFromParentViewController ];
   }
   else
   {
      [ controller_ viewWillDisappear: animated_ ];
   }

   [ controller_.view removeFromSuperview ];

   if ( ![ self supportsChildrenControllers ] )
   {
      [ controller_ viewDidDisappear: animated_ ];
   }
}

@end

@interface DDMenuController ()

@property ( nonatomic, assign ) BOOL showRootInProgress;
@property ( nonatomic, strong ) NSMutableSet* panIgnorableClasses;

- (void)showShadow:(BOOL)val;

@end

@implementation DDMenuController

@synthesize showRootInProgress;

@synthesize delegate, barButtonItemClass;

@synthesize leftViewController=_left;
@synthesize rightViewController=_right;
@synthesize rootViewController=_root;

@synthesize tap=_tap;
@synthesize pan=_pan;

+ (CGFloat)displayControllerWidth
{
   return kMenuDisplayedWidth;
}

- (id)initWithRootViewController:(UIViewController*)controller {
    if ((self = [self init])) {
        _root = controller;
    }
    return self;
}

- (id)init {
    if ((self = [super init])) {
        self.barButtonItemClass = [UIBarButtonItem class];
        self.panIgnorableClasses = [NSMutableSet new];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    _tap = nil;
    _pan = nil;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRootViewController:_root]; // reset root
   
    if (!_tap) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tap.delegate = (id<UIGestureRecognizerDelegate>)self;
        [self.view addGestureRecognizer:tap];
        [tap setEnabled:NO];
        _tap = tap;
    }
    
}

-(UIViewController*)currentController
{
   if (_menuFlags.showingRightView)
      return _right;
   else if (_menuFlags.showingLeftView)
      return _left;

   return _root;
}

-(BOOL)shouldAutorotate
{
   return [self.currentController shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations
{
   return [self.currentController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
   return [self.currentController preferredInterfaceOrientationForPresentation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return [self.currentController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];

    if (_root) {
        
        [_root willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];

        /*UIView *view = _root.view;

        if (_menuFlags.showingRightView) {

            view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            
        } else if (_menuFlags.showingLeftView) {
           
            view.autoresizingMask = UIViewAutoresizingFlexibleHeight;

        } else {
            
            view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            
        }*/
        
    }
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];

    if (_root) {
        
        [_root didRotateFromInterfaceOrientation:fromInterfaceOrientation];

        CGRect frame = self.view.bounds;
        if (_menuFlags.showingLeftView) {
            frame.origin.x = frame.size.width - kMenuOverlayWidth;
        } else if (_menuFlags.showingRightView) {
            frame.origin.x = -(frame.size.width - kMenuOverlayWidth);
        }
        _root.view.frame = frame;
        //_root.view.autoresizingMask = self.view.autoresizingMask;
        
        [self showShadow:(_root.view.layer.shadowOpacity!=0.0f)];
        
    }
    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];

    if (_root) {
        [_root willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }
    
}


#pragma mark - GestureRecognizers

- (void)pan:(UIPanGestureRecognizer*)gesture {

    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        [self showShadow:YES];
        _panOriginX = self.view.frame.origin.x;        
        _panVelocity = CGPointMake(0.0f, 0.0f);
        
        if([gesture velocityInView:self.view].x > 0) {
            _panDirection = DDMenuPanDirectionRight;
        } else {
            _panDirection = DDMenuPanDirectionLeft;
        }

    }
   
    if (gesture.state == UIGestureRecognizerStateChanged) {
        
        CGPoint velocity = [gesture velocityInView:self.view];
        if((velocity.x*_panVelocity.x + velocity.y*_panVelocity.y) < 0) {
            _panDirection = (_panDirection == DDMenuPanDirectionRight) ? DDMenuPanDirectionLeft : DDMenuPanDirectionRight;
        }
        
        _panVelocity = velocity;        
        CGPoint translation = [gesture translationInView:self.view];
        CGRect frame = _root.view.frame;
        frame.origin.x = _panOriginX + translation.x;
        
        if (frame.origin.x > 0.0f && !_menuFlags.showingLeftView) {
            
            if(_menuFlags.showingRightView) {
                _menuFlags.showingRightView = NO;
                [self.rightViewController.view removeFromSuperview];
            }
            
            if (_menuFlags.canShowLeft) {
                
                _menuFlags.showingLeftView = YES;
               CGRect frame = self.view.bounds;
               frame.size.width = kMenuFullWidth;
               [ self insertController: self.leftViewController
                               atIndex: 0
                                 frame: frame
                      autoresizingMask: UIViewAutoresizingFlexibleHeight
                              animated: YES ];
            } else {
                frame.origin.x = 0.0f; // ignore right view if it's not set
            }
            
        } else if (frame.origin.x < 0.0f && !_menuFlags.showingRightView) {
            
            if(_menuFlags.showingLeftView) {
                _menuFlags.showingLeftView = NO;
                [self.leftViewController.view removeFromSuperview];
            }
            
            if (_menuFlags.canShowRight) {
                
                _menuFlags.showingRightView = YES;
               CGRect frame = self.view.bounds;
               frame.origin.x += frame.size.width - kMenuFullWidth;
               frame.size.width = kMenuFullWidth;
               [ self insertController: self.rightViewController
                               atIndex: 0
                                 frame: frame
                      autoresizingMask: UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin
                              animated: YES ];
            } else {
                frame.origin.x = 0.0f; // ignore left view if it's not set
            }
            
        }
        
        _root.view.frame = frame;

    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
       
       //Hide keyboar
       [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
       
        //  Finishing moving to left, right or root view with current pan velocity
        [self.view setUserInteractionEnabled:NO];
        
        DDMenuPanCompletion completion = DDMenuPanCompletionRoot; // by default animate back to the root
        
        if (_panDirection == DDMenuPanDirectionRight && _menuFlags.showingLeftView) {
            completion = DDMenuPanCompletionLeft;
        } else if (_panDirection == DDMenuPanDirectionLeft && _menuFlags.showingRightView) {
            completion = DDMenuPanCompletionRight;
        }
        
        CGPoint velocity = [gesture velocityInView:self.view];    
        if (velocity.x < 0.0f) {
            velocity.x *= -1.0f;
        }
        BOOL bounce = (velocity.x > 800);
        CGFloat originX = _root.view.frame.origin.x;
        CGFloat width = _root.view.frame.size.width;
        CGFloat span = (width - kMenuOverlayWidth);
        CGFloat duration = kMenuSlideDuration; // default duration with 0 velocity
        
        
        if (bounce) {
            duration = (span / velocity.x); // bouncing we'll use the current velocity to determine duration
        } else {
            duration = ((span - originX) / span) * duration; // user just moved a little, use the defult duration, otherwise it would be too slow
        }
        
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            if (completion == DDMenuPanCompletionLeft) {
                [self showLeftController:NO];
            } else if (completion == DDMenuPanCompletionRight) {
                [self showRightController:NO];
            } else {
                [self showRootController:NO];
            }
            [_root.view.layer removeAllAnimations];
            [self.view setUserInteractionEnabled:YES];
        }];
        
        CGPoint pos = _root.view.layer.position;
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        
        NSMutableArray *keyTimes = [[NSMutableArray alloc] initWithCapacity:bounce ? 3 : 2];
        NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:bounce ? 3 : 2];
        NSMutableArray *timingFunctions = [[NSMutableArray alloc] initWithCapacity:bounce ? 3 : 2];
        
        [values addObject:[NSValue valueWithCGPoint:pos]];
        [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        [keyTimes addObject:[NSNumber numberWithFloat:0.0f]];
        if (bounce) {
            
            duration += kMenuBounceDuration;
            [keyTimes addObject:[NSNumber numberWithFloat:1.0f - ( kMenuBounceDuration / duration)]];
            if (completion == DDMenuPanCompletionLeft) {
                
                [values addObject:[NSValue valueWithCGPoint:CGPointMake(((width/2) + span) + kMenuBounceOffset, pos.y)]];
                
            } else if (completion == DDMenuPanCompletionRight) {
                
                [values addObject:[NSValue valueWithCGPoint:CGPointMake(-((width/2) - (kMenuOverlayWidth-kMenuBounceOffset)), pos.y)]];
                
            } else {
                
                // depending on which way we're panning add a bounce offset
                if (_panDirection == DDMenuPanDirectionLeft) {
                    [values addObject:[NSValue valueWithCGPoint:CGPointMake((width/2) - kMenuBounceOffset, pos.y)]];
                } else {
                    [values addObject:[NSValue valueWithCGPoint:CGPointMake((width/2) + kMenuBounceOffset, pos.y)]];
                }
                
            }
            
            [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            
        }
        if (completion == DDMenuPanCompletionLeft) {
            [values addObject:[NSValue valueWithCGPoint:CGPointMake((width/2) + span, pos.y)]];
        } else if (completion == DDMenuPanCompletionRight) {
            [values addObject:[NSValue valueWithCGPoint:CGPointMake(-((width/2) - kMenuOverlayWidth), pos.y)]];
        } else {
            [values addObject:[NSValue valueWithCGPoint:CGPointMake(width/2, pos.y)]];
        }
        
        [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [keyTimes addObject:[NSNumber numberWithFloat:1.0f]];
        
        animation.timingFunctions = timingFunctions;
        animation.keyTimes = keyTimes;
        //animation.calculationMode = @"cubic";
        animation.values = values;
        animation.duration = duration;   
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        [_root.view.layer addAnimation:animation forKey:nil];
        [CATransaction commit];   
    
    }    
    
}

- (void)tap:(UITapGestureRecognizer*)gesture {
   
    [gesture setEnabled:NO];
    [self showRootController:YES];
    
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {

    // Check for horizontal pan gesture
    if (gestureRecognizer == _pan) {

        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer*)gestureRecognizer;
        CGPoint translation = [panGesture translationInView:self.view];

        if ([panGesture velocityInView:self.view].x < 600 && sqrt(translation.x * translation.x) / sqrt(translation.y * translation.y) > 1) {
            return YES;
        } 
        
        return NO;
    }
    
    if (gestureRecognizer == _tap) {
        
        if (_root && (_menuFlags.showingRightView || _menuFlags.showingLeftView)) {
            return CGRectContainsPoint(_root.view.frame, [gestureRecognizer locationInView:self.view]);
        }
        
        return NO;
        
    }

    return YES;
   
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer==_tap) {
        return YES;
    }     
    return NO;
}

- (void)ingnorePanForViewClass:( Class )class_
{
   [ self.panIgnorableClasses addObject: class_ ];
}

- (BOOL)shouldIgnoreView:( UIView* )view_
{
   for ( Class view_class_ in self.panIgnorableClasses )
   {
      if ( [ view_ isKindOfClass: view_class_ ] || [ view_.superview isKindOfClass: view_class_ ] )
         return YES;
   }

   return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch_
{
   if (gestureRecognizer==_pan) {
      return ![ self shouldIgnoreView: touch_.view ];
   }

   return YES;
}

#pragma Internal Nav Handling 

- (void)resetNavButtons {
   if (!_root) return;
   
   UIViewController *topController = nil;
   if ([_root isKindOfClass:[UINavigationController class]]) {
      
      UINavigationController *navController = (UINavigationController*)_root;
      if ([[navController viewControllers] count] > 0) {
         topController = [[navController viewControllers] objectAtIndex:0];
      }
      
   } else if ([_root isKindOfClass:[UITabBarController class]]) {
      
      UITabBarController *tabController = (UITabBarController*)_root;
      topController = [tabController selectedViewController];
      
   } else {
      
      topController = _root;
      
   }
   
   if (_menuFlags.canShowLeft) {
      UIBarButtonItem *button = [[barButtonItemClass alloc] initWithImage:[UIImage imageNamed:@"PFMenuIcon.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(showLeft:)];
      topController.navigationItem.leftBarButtonItem = button;
   } else {
		if(topController.navigationItem.leftBarButtonItem.target == self) {
			topController.navigationItem.leftBarButtonItem = nil;
		}
   }

   BOOL can_add_buttons_ = [ UINavigationItem instancesRespondToSelector: @selector(leftBarButtonItems) ];
   NSArray* buttons_ = [ self.delegate leftBarButtonItemsInMenuController: self ];
   if ( can_add_buttons_ && [ buttons_ count ] > 0 )
   {
      NSMutableArray* items_ = [ NSMutableArray arrayWithObject: topController.navigationItem.leftBarButtonItem ];
      [ items_ addObjectsFromArray: buttons_ ];
      topController.navigationItem.leftBarButtonItems = items_;
   }

    /*if (_menuFlags.canShowRight) {
        UIBarButtonItem *button = [[barButtonItemClass alloc] initWithImage:[UIImage imageNamed:@"PFMenuIcon.png"] style:UIBarButtonItemStyleBordered  target:self action:@selector(showRight:)];
        topController.navigationItem.rightBarButtonItem = button;
    } else {
		if(topController.navigationItem.rightBarButtonItem.target == self) {
			topController.navigationItem.rightBarButtonItem = nil;
		}
    }*/
}

- (void)showShadow:(BOOL)val {
    if (!_root) return;
    
    _root.view.layer.shadowOpacity = val ? 0.8f : 0.0f;
    if (val) {
        _root.view.layer.cornerRadius = 4.0f;
        _root.view.layer.shadowOffset = CGSizeMake( -3.f, -3.f );
        _root.view.layer.shadowRadius = 4.0f;

        //_root.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
    }
    
}

- (void)showRootController:(BOOL)animated {
   if ( self.showRootInProgress )
      return;
   
   self.showRootInProgress = YES;
   
   [_tap setEnabled:NO];
   _root.view.userInteractionEnabled = YES;
   

   BOOL _enabled = [UIView areAnimationsEnabled];
   if (!animated) {
      [UIView setAnimationsEnabled:NO];
   }
   
   [UIView animateWithDuration:.3 animations:^{
      CGRect frame = _root.view.frame;
      frame.origin.x = 0.0f;
      _root.view.frame = frame;
      
   } completion:^(BOOL finished) {
      self.showRootInProgress = NO;
      
      if (_left && _left.view.superview) {
         [_left.view removeFromSuperview];
      }
      
      if (_right && _right.view.superview) {
         [_right.view removeFromSuperview];
      }
      
      _menuFlags.showingLeftView = NO;
      _menuFlags.showingRightView = NO;
      
      [self showShadow:NO];
      
   }];
   
   if (!animated) {
      [UIView setAnimationsEnabled:_enabled];
   }
}

- (void)showLeftController:(BOOL)animated {
    if (!_menuFlags.canShowLeft) return;
    
    if (_right && _right.view.superview) {
        [_right.view removeFromSuperview];
        _menuFlags.showingRightView = NO;
    }
    
    if (_menuFlags.respondsToWillShowViewController) {
        [self.delegate menuController:self willShowViewController:self.leftViewController];
    }
    _menuFlags.showingLeftView = YES;
    [self showShadow:YES];

	CGRect frame = self.view.bounds;
	frame.size.width = kMenuFullWidth;

   [ self insertController: self.leftViewController
                   atIndex: 0
                     frame: frame
          autoresizingMask: UIViewAutoresizingFlexibleHeight
                  animated: animated ];

    frame = _root.view.frame;
    frame.origin.x = CGRectGetMaxX(self.leftViewController.view.frame) - (kMenuFullWidth - kMenuDisplayedWidth);

    BOOL _enabled = [UIView areAnimationsEnabled];
    if (!animated) {
        [UIView setAnimationsEnabled:NO];
    }
    
    _root.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:.3 animations:^{
        _root.view.frame = frame;
    } completion:^(BOOL finished) {
        [_tap setEnabled:YES];
    }];
    
    if (!animated) {
        [UIView setAnimationsEnabled:_enabled];
    }
    
}

- (void)showRightController:(BOOL)animated {
    if (!_menuFlags.canShowRight) return;
     
   //+++
   _menuFlags.canShowRight = NO;
   
    if (_left && _left.view.superview) {
        [_left.view removeFromSuperview];
        _menuFlags.showingLeftView = NO;
    }
    
    if (_menuFlags.respondsToWillShowViewController) {
        [self.delegate menuController:self willShowViewController:self.rightViewController];
    }
    _menuFlags.showingRightView = YES;
    [self showShadow:YES];

    CGRect frame = self.view.bounds;
	frame.origin.x += frame.size.width - kMenuFullWidth;
	frame.size.width = kMenuFullWidth;

   [ self insertController: self.rightViewController
                   atIndex: 0
                     frame: frame
          autoresizingMask: UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin
                  animated: animated ];

    frame = _root.view.frame;
    frame.origin.x = -(frame.size.width - kMenuOverlayWidth);
    
    BOOL _enabled = [UIView areAnimationsEnabled];
    if (!animated) {
        [UIView setAnimationsEnabled:NO];
    }
    
    _root.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:.3 animations:^{
        _root.view.frame = frame;
    } completion:^(BOOL finished) {
        [_tap setEnabled:YES];
    }];
    
    if (!animated) {
        [UIView setAnimationsEnabled:_enabled];
    }
}


#pragma mark Setters

- (void)setDelegate:(id<DDMenuControllerDelegate>)val {
    delegate = val;
    _menuFlags.respondsToWillShowViewController = [(id)self.delegate respondsToSelector:@selector(menuController:willShowViewController:)];    
}

- (void)setRightViewController:(UIViewController *)rightController {
   if ( _right != rightController )
   {
      [ _right setMenuController: nil ];
      [ self removeController: _right animated: YES ];
      _right = rightController;
      [ _right setMenuController: self ];
      _menuFlags.canShowRight = (_right!=nil);
      [self resetNavButtons];
   }
}

- (void)setLeftViewController:(UIViewController *)leftController {
   if ( _left != leftController )
   {
      [ _left setMenuController: nil ];
      [ self removeController: _left animated: YES ];
      _left = leftController;
      [ _left setMenuController: self ];
      _menuFlags.canShowLeft = (_left!=nil);
      [self resetNavButtons];
   }
   
   if ( _menuFlags.showingLeftView )
   {
      [ self showLeftController: NO ];
   }
}

- (void)setPrivateRootViewController:(UIViewController *)rootViewController animated:( BOOL )animated_
{
   UIViewController *tempRoot = _root;
   _root = rootViewController;

   if (tempRoot) {
      
      [ tempRoot setMenuController: nil ];
      [self removeController: tempRoot animated: animated_ ];

      tempRoot = nil;
   }

   if (_root) {
      [ _root setMenuController: self ];
      [self addController: _root animated: animated_ ];

      UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
      pan.delegate = (id<UIGestureRecognizerDelegate>)self;
      [_root.view addGestureRecognizer:pan];
      _pan = pan;
      
   }

   [self resetNavButtons];
}

- (void)setRootViewController:(UIViewController *)rootViewController
{
   if ( self.showRootInProgress )
      return;

   [ self setPrivateRootViewController: rootViewController animated: NO ];
}

- (void)setRootController:(UIViewController *)controller animated:(BOOL)animated {
   if ( self.showRootInProgress )
      return;

    if (!controller) {
        [ self setPrivateRootViewController: controller animated: NO ];
        return;
    }
    
    if (_menuFlags.showingLeftView) {
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        // slide out then come back with the new root
        __block DDMenuController *selfRef = self;
        __block UIViewController *rootRef = _root;
        CGRect frame = rootRef.view.frame;
        frame.origin.x = rootRef.view.bounds.size.width;
        
        [UIView animateWithDuration:.1 animations:^{
            
            rootRef.view.frame = frame;
            
        } completion:^(BOOL finished) {
            
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];

            [ selfRef setPrivateRootViewController: controller animated: animated ];

            _root.view.frame = frame;
            [selfRef showRootController:animated];
            
        }];
        
    } else {
        
        // just add the root and move to it if it's not center
        [self setRootViewController:controller];
        [self showRootController:animated];
        
    }
     
}


#pragma mark - Root Controller Navigation

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    NSAssert((_root!=nil), @"no root controller set");
    
    UINavigationController *navController = nil;
    
    if ([_root isKindOfClass:[UINavigationController class]]) {
    
        navController = (UINavigationController*)_root;
    
    } else if ([_root isKindOfClass:[UITabBarController class]]) {
        
        UIViewController *topController = [(UITabBarController*)_root selectedViewController];
        if ([topController isKindOfClass:[UINavigationController class]]) {
            navController = (UINavigationController*)topController;
        }
        
    } 
    
    if (navController == nil) {
       
        NSLog(@"root controller is not a navigation controller.");
        return;
    }
    
   
    if (_menuFlags.showingRightView) {
        
        // if we're showing the right it works a bit different, we'll make a screen shot of the menu overlay, then push, and move everything over
        __block CALayer *layer = [CALayer layer];
        CGRect layerFrame = self.view.bounds;
        layer.frame = layerFrame;
        
        UIGraphicsBeginImageContextWithOptions(layerFrame.size, YES, 0);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        [self.view.layer renderInContext:ctx];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        layer.contents = (id)image.CGImage;
        
        [self.view.layer addSublayer:layer];
        [navController pushViewController:viewController animated:NO];
        CGRect frame = _root.view.frame;
        frame.origin.x = frame.size.width;
        _root.view.frame = frame;
        frame.origin.x = 0.0f;
        
        CGAffineTransform currentTransform = self.view.transform;
        
        [UIView animateWithDuration:0.25f animations:^{
            
            if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
                
                  self.view.transform = CGAffineTransformConcat(currentTransform, CGAffineTransformMakeTranslation(0, -[[UIScreen mainScreen] applicationFrame].size.height));
                
            } else {
                
                  self.view.transform = CGAffineTransformConcat(currentTransform, CGAffineTransformMakeTranslation(-[[UIScreen mainScreen] applicationFrame].size.width, 0));
            }
          
            
        } completion:^(BOOL finished) {
            
            [self showRootController:NO];
            self.view.transform = CGAffineTransformConcat(currentTransform, CGAffineTransformMakeTranslation(0.0f, 0.0f));
            [layer removeFromSuperlayer];
            
        }];
        
    } else {
        
        [navController pushViewController:viewController animated:animated];
        
    }
    
}


#pragma mark - Actions 

- (void)showLeft:(id)sender {
    
    [self showLeftController:YES];
    
}

- (void)showRight:(id)sender {
    
    [self showRightController:YES];
    
}

@end

@implementation NSObject (DDMenuControllerDelegate)

- (void)menuController:( DDMenuController* )menu_controller_
willShowViewController:( UIViewController* )view_controller_
{
}

-(NSArray*)leftBarButtonItemsInMenuController:( DDMenuController* )menu_controller_
{
   return nil;
}

@end
