//
//  PFChoicesViewController.m
//  PFTrader
//
//  Created by Denis on 18.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFChoicesViewController.h"
#import "PFSegmentedControl.h"
#import "UIColor+Skin.h"
#import "UIImage+Skin.h"

@interface PFChoicesViewControllerSource ()

@property ( nonatomic, strong ) NSString* title;
@property ( nonatomic, strong ) UIViewController* controller;

@end

@implementation PFChoicesViewControllerSource

@synthesize title;
@synthesize controller;

+(id)sourceWithTitle:( NSString* )title_
          controller:( UIViewController* )controller_
{
   PFChoicesViewControllerSource* source_ = [ [ PFChoicesViewControllerSource alloc ] init ];
   source_.title = title_;
   source_.controller = controller_;
   
   return source_;
}

@end

@interface PFChoicesViewController () < PFSegmentedControlDelegate >

@property ( nonatomic, strong ) NSArray* sources;
@property ( nonatomic, assign ) NSUInteger activeSourceIndex;

@end

@implementation PFChoicesViewController

@synthesize choicesImageView;
@synthesize choicesControl;
@synthesize contentView;
@synthesize sources;
@synthesize activeSourceIndex;

+(id)choicesControllerWithSources:( NSArray* )sources_
                            title:( NSString* )title_
{
   PFChoicesViewController* choices_controller_ = [ [ PFChoicesViewController alloc ] initWithNibName: NSStringFromClass( [ self class ] )
                                                                                               bundle: nil ];
   
   choices_controller_.title = title_;
   choices_controller_.sources = sources_;
   choices_controller_.activeSourceIndex = 0;
   
   return choices_controller_;
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   self.choicesControl.items = [ self.sources valueForKeyPath: @"@unionOfObjects.title" ];
   self.choicesControl.selectedSegmentIndex = self.activeSourceIndex;
   
//   self.choicesImageView.backgroundColor = [ UIColor backgroundLightColor ];
//   self.choicesImageView.image = [ UIImage thinShadowImage ];
}

-(void)viewWillAppear:( BOOL )animated_
{
   [ super viewWillAppear:animated_ ];
   
   for ( PFChoicesViewControllerSource* source_ in self.sources )
   {
      [ source_.controller viewWillAppear: animated_ ];
   }
}

-(void)viewDidAppear:(BOOL)animated_
{
   [ super viewDidAppear: animated_ ];
   
   for ( PFChoicesViewControllerSource* source_ in self.sources )
   {
      [ source_.controller viewDidAppear: animated_ ];
   }
}

-(void)viewWillDisappear:( BOOL )animated_
{
   [ super viewWillDisappear: animated_ ];
   
   for ( PFChoicesViewControllerSource* source_ in self.sources )
   {
      [ source_.controller viewWillDisappear: animated_ ];
   }
}

-(void)viewDidDisappear:( BOOL )animated_
{
   [ super viewDidDisappear: animated_ ];
   
   for ( PFChoicesViewControllerSource* source_ in self.sources )
   {
      [ source_.controller viewDidDisappear: animated_ ];
   }
}

-(void)setChoicesImageViewHidden:( BOOL )hidden_
{
   self.choicesImageView.hidden = hidden_;
   CGRect content_view_frame_ = self.contentView.frame;
   
   content_view_frame_.origin.y = hidden_ ? 0.f : self.choicesImageView.frame.size.height;
   content_view_frame_.size.height = hidden_ ? self.view.frame.size.height : self.view.frame.size.height - self.choicesImageView.frame.size.height;
   
   self.contentView.frame = content_view_frame_;
}

#pragma mark - PFSegmentedControlDelegate

-(void)segmentedControl:( PFSegmentedControl* )segmented_control_
   didSelectItemAtIndex:( NSInteger )index_
{
   [ self.contentView.subviews makeObjectsPerformSelector: @selector( removeFromSuperview ) ];
   
   self.activeSourceIndex = index_;
   
   PFChoicesViewControllerSource* active_source_ = [ self.sources objectAtIndex: self.activeSourceIndex ];
   active_source_.controller.view.frame = self.contentView.bounds;
   active_source_.controller.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   [ self.contentView addSubview: active_source_.controller.view ];
   
}

@end
