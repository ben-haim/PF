#import "ESButtonGroupController.h"

#import "ESButtonGroupControllerDelegate.h"
#import "ESSelectableButton.h"

//#import <JFFUI/UIView/UIView+AllSubviews.h>

@interface ESButtonGroupController ()

@property ( nonatomic, retain ) NSArray* selectableButtons;

@property ( nonatomic, retain ) NSMutableSet* mutableActiveIndexes;

@end

@implementation ESButtonGroupController

@synthesize view;
@synthesize delegate;
@synthesize selectableButtons;
@synthesize mutableActiveIndexes = _mutable_active_indexes;
@synthesize allowsMultipleSelection;
@dynamic buttons;

-(NSMutableSet*)mutableActiveIndexes
{
   if ( !_mutable_active_indexes )
   {
      _mutable_active_indexes = [ NSMutableSet new ];
   }
   
   return _mutable_active_indexes;
}

-(NSArray*)buttons
{
   return self.selectableButtons;
}

-(void)activateItemWithIndex:( NSInteger )active_index_
{
   ESSelectableButton* selected_button_ = [ self.selectableButtons objectAtIndex: active_index_ ];
   selected_button_.selected = YES;

   [ self.mutableActiveIndexes addObject: [ NSNumber numberWithInt: (int)active_index_ ] ];

   [ self.delegate groupController: self didChangeButtonState: selected_button_ ];
}

-(void)deactivateItemWithIndex:( NSInteger )active_index_
{
   ESSelectableButton* selected_button_ = [ self.selectableButtons objectAtIndex: active_index_ ];
   selected_button_.selected = NO;

   [ self.mutableActiveIndexes removeObject: [ NSNumber numberWithInt: (int)active_index_ ] ];

   [ self.delegate groupController: self didChangeButtonState: selected_button_ ];
}

-(NSSet*)activeIndexes
{
   return self.mutableActiveIndexes;
}

-(void)deselectAll
{
   for ( NSNumber* active_index_ in self.mutableActiveIndexes )
   {
      [ self deactivateItemWithIndex: [ active_index_ intValue ] ];
   }

   self.mutableActiveIndexes = nil;
}

-(void)setActiveIndexes:( NSSet* )active_indexes_
{
   [ self deselectAll ];

   self.mutableActiveIndexes = [ NSMutableSet set ];
   for ( NSNumber* active_index_ in active_indexes_ )
   {
      [ self activateItemWithIndex: [ active_index_ intValue ] ];
   }
}

-(void)setActiveIndex:( NSInteger )active_index_
{
   [ self setActiveIndexes: [ NSSet setWithObject: [ NSNumber numberWithInt: (int)active_index_ ] ] ];
}

-(void)setTitle:( NSString* )title_ forButtonAtIndex:( NSUInteger )index_
{
   UIButton* button_ = [ self.selectableButtons objectAtIndex: index_ ];
   NSAssert( button_, @"undefined button index" );
   [ button_ setTitle: title_ forState: UIControlStateNormal ];
}

-(void)setButtons:( NSArray* )buttons_
{
   [ self.view.subviews makeObjectsPerformSelector: @selector( removeFromSuperview ) ];

   self.selectableButtons = buttons_;

   NSMutableSet* active_indexes_ = [ NSMutableSet set ];

   for ( NSUInteger button_index_ = 0; button_index_ < [ self.selectableButtons count ]; ++button_index_ )
   {
      ESSelectableButton* check_box_ = [ self.selectableButtons objectAtIndex: button_index_ ];
      check_box_.delegate = self;

      if ( check_box_.selected )
      {
         [ active_indexes_ addObject: [ NSNumber numberWithInt: (int)button_index_ ] ];
      }

      [ self.view addSubview: check_box_ ];
   }

   self.mutableActiveIndexes = active_indexes_;
}

-(void)buttonDidChangeState:( ESSelectableButton* )check_box_
{
   if ( !self.allowsMultipleSelection )
   {
      for ( NSNumber* selected_index_ in self.activeIndexes )
      {
         UIButton* selected_button_ = [ self.selectableButtons objectAtIndex: [ selected_index_ intValue ] ];
         selected_button_.selected = NO;
      }
      self.mutableActiveIndexes = nil;
   }

   NSInteger index_ = [ self.selectableButtons indexOfObject: check_box_ ];
   if ( check_box_.selected )
   {
      [ self activateItemWithIndex: index_ ];
   }
   else
   {
      [ self deactivateItemWithIndex: index_ ];
   }

   [ self.delegate groupController: self didClickButton: check_box_ ];
}

-(BOOL)disableChangeStateForButton:( ESSelectableButton* )button_
{
   return [ self.delegate groupController: self disableButtonSelection: button_ ];
}

-(ESSelectableButton*)buttonAtIndex:( NSUInteger )index_
{
   return [ self.selectableButtons objectAtIndex: index_ ];
}

-(NSInteger)indexOfButton:( UIButton* )button_
{
   return [ self.selectableButtons indexOfObject: button_ ];
}

@end
