#import "PFSegmentedControl.h"

#import "PFSegmentedLayout.h"

#import "UIImage+Skin.h"
#import "UIColor+Skin.h"

#import <ESButtonGroup/ESButtonGroup.h>

@interface ESSelectableButton (PFSegmentedControl)

+(id)leftButtonWithTitle:( NSString* )title_;
+(id)centerButtonWithTitle:( NSString* )title_;
+(id)rightButtonWithTitle:( NSString* )title_;

@end

@implementation ESSelectableButton (PFSegmentedControl)

+(id)selectableButtonWithTitle:( NSString* )title_
                    background:( UIImage* )image_
            selectedBackground:( UIImage* )selected_image_
{
   ESSelectableButton* selectable_button_ = [ ESSelectableButton selectableButton ];

   [ selectable_button_ setTitleColor: [ UIColor mainTextColor ] forState: UIControlStateSelected ];
   [ selectable_button_ setTitleColor: [ UIColor mainTextColor ] forState: UIControlStateNormal ];

   [ selectable_button_ setTitle: title_ forState: UIControlStateNormal ];
   [ selectable_button_ setBackgroundImage: image_ forState: UIControlStateNormal ];
   [ selectable_button_ setBackgroundImage: selected_image_ forState: UIControlStateSelected ];

   selectable_button_.titleLabel.shadowColor = [ UIColor clearColor ];
   selectable_button_.titleLabel.shadowOffset = CGSizeMake( 0.f, 0.f );
   
   return selectable_button_;
}

+(id)leftButtonWithTitle:( NSString* )title_
{
   return [ self selectableButtonWithTitle: title_
                                background: [ UIImage leftSegmentBackground ]
                        selectedBackground: [ UIImage selectedLeftSegmentBackground ] ];
}

+(id)centerButtonWithTitle:( NSString* )title_
{
   return [ self selectableButtonWithTitle: title_
                                background: [ UIImage centerSegmentBackground ]
                        selectedBackground: [ UIImage selectedCenterSegmentBackground ] ];
}

+(id)rightButtonWithTitle:( NSString* )title_
{
   return [ self selectableButtonWithTitle: title_
                                background: [ UIImage rightSegmentBackground ]
                        selectedBackground: [ UIImage selectedRightSegmentBackground ] ];
}

@end

@interface PFSegmentedControl ()< ESButtonGroupControllerDelegate >

@property ( nonatomic, strong, readonly ) ESButtonGroupController* groupController;
@property ( nonatomic, strong, readonly ) PFSegmentedLayout* layout;

@end

@implementation PFSegmentedControl

@synthesize groupController = _groupController;
@synthesize layout = _layout;
@synthesize font;
@synthesize delegate;

-(ESButtonGroupController*)groupController
{
   if ( !_groupController )
   {
      _groupController = [ ESButtonGroupController new ];
      _groupController.view = self.layout;
      _groupController.delegate = self;
   }
   return _groupController;
}

-(PFSegmentedLayout*)layout
{
   if ( !_layout )
   {
      _layout = [ [ PFSegmentedLayout alloc ] initWithFrame: self.bounds ];
      _layout.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
      [ self addSubview: _layout ];
   }
   return _layout;
}

-(void)setButtons:( NSArray* )buttons_
{
   self.layout.segmentsCount = [ buttons_ count ];
   self.groupController.buttons = buttons_;
}

-(void)setItems:( NSArray* )items_
{
   NSAssert( [ items_ count ] > 1, @"invalid items count" );

   NSMutableArray* buttons_ = [ NSMutableArray arrayWithCapacity: [ items_ count ] ];
   for ( NSUInteger i_ = 0; i_ < [ items_ count ]; ++i_ )
   {
      NSString* title_ = [ items_ objectAtIndex: i_ ];
      UIButton* button_ = nil;
      if ( i_ == 0 )
      {
         button_ = [ ESSelectableButton leftButtonWithTitle: title_ ];
      }
      else if ( i_ == [ items_ count ] - 1 )
      {
         button_ = [ ESSelectableButton rightButtonWithTitle: title_ ];
      }
      else
      {
         button_ = [ ESSelectableButton centerButtonWithTitle: title_ ];
      }
      button_.titleLabel.font = self.font;
      [ buttons_ addObject: button_ ];
   }

   [ self setButtons: buttons_ ];
}

-(void)applyStyle
{
   self.font = [ UIFont systemFontOfSize: 14.f ];
}

-(void)awakeFromNib
{
   [ self applyStyle ];
}

-(id)initWithFrame:( CGRect )frame_
{
   self = [ super initWithFrame: frame_ ];
   if ( self )
   {
      [ self applyStyle ];
   }
   return self;
}

-(id)init
{
   return [ self initWithFrame: CGRectMake( 0.f, 0.f, 100.f, 40.f ) ];
}

-(id)initWithItems:( NSArray* )items_
{
   self = [ self init ];
   if ( self )
   {
      self.items = items_;
   }
   return self;
}

-(id)initWithButtons:( NSArray* )buttons_
{
   self = [ self init ];
   if ( self )
   {
      self.buttons = buttons_;
   }
   return self;
}

-(NSInteger)selectedSegmentIndex
{
   NSSet* active_indexes_ = self.groupController.activeIndexes;
   if ( [ active_indexes_ count ] == 0 )
   {
      return UISegmentedControlNoSegment;
   }
   return [ [ active_indexes_ anyObject ] integerValue ];
}

-(void)setSelectedSegmentIndex:( NSInteger )index_
{
   [ self.groupController setActiveIndex: index_ ];
}

-(NSUInteger)numberOfSegments
{
   return [ self.groupController.buttons count ];
}

#pragma mark ESButtonGroupController

-(void)groupController:( ESButtonGroupController* )group_controller_
  didChangeButtonState:( ESSelectableButton* )button_
{
   [ self.delegate segmentedControl: self
               didSelectItemAtIndex: self.selectedSegmentIndex ];
}

@end
