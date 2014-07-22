#import "PFTableViewDashItem.h"

#import "PFIndicator.h"

#import "PFFrameView.h"

@interface PFTableViewDashItem ()

@property ( nonatomic, strong ) PFIndicatorAttributeDash* dash;

@property ( nonatomic, strong ) NSArray* availableLines;

@end

@implementation PFTableViewDashItem

@synthesize dash;
@synthesize availableLines;

-(id)initWithDash:( PFIndicatorAttributeDash* )dash_
{
   self = [ super initWithAction: nil title: dash_.title ];
   if ( self )
   {
      self.dash = dash_;
      self.availableLines = @[ [ UIImage imageNamed: @"PFLineType1" ]
      , [ UIImage imageNamed: @"PFLineType2" ]
      , [ UIImage imageNamed: @"PFLineType3" ]
      , [ UIImage imageNamed: @"PFLineType4" ]
      , [ UIImage imageNamed: @"PFLineType5" ]
      , [ UIImage imageNamed: @"PFLineType6" ]
      , [ UIImage imageNamed: @"PFLineType7" ]
      ];
   }
   return self;
}

-(PFFrameView*)frameViewForDash:( NSUInteger )dash_
{
   UIImageView* image_view_ = [ [ UIImageView alloc ] initWithImage: [ self.availableLines objectAtIndex: dash_ ] ];
   image_view_.backgroundColor = [ UIColor whiteColor ];
   image_view_.contentMode = UIViewContentModeCenter;

   PFFrameView* frame_view_ = [ PFFrameView new ];
   frame_view_.contentView = image_view_;
   return frame_view_;
}

-(void)updatePickerField:( PFPickerField* )picker_field_
{
   picker_field_.overlayView = [ self frameViewForDash: self.dash.dash ];
}

-(NSUInteger)pickerField:( PFPickerField* )picker_field_
 numberOfRowsInComponent:( NSInteger )component_
{
   return [ self.availableLines count ];
}

-(UIView*)pickerField:( PFPickerField* )picker_field_
           viewForRow:( NSInteger )row_
         forComponent:( NSInteger )component_
          reusingView:( UIView* )view_
{
   PFFrameView* frame_view_ = (PFFrameView*)view_;
   
   if ( !frame_view_ )
   {
      CGRect view_rect_ = CGRectZero;
      view_rect_.size = [ picker_field_ rowSizeForComponent: component_ ];
      frame_view_ = [ self frameViewForDash: row_ ];
      frame_view_.frame = CGRectInset( view_rect_, 60.f, 5.f );
   }
   else
   {
      UIImageView* image_view_ = ( UIImageView* )frame_view_.contentView;
      image_view_.image = [ self.availableLines objectAtIndex: row_ ];
   }

   return frame_view_;
}

-(NSUInteger)pickerField:( PFPickerField* )picker_field_
   currentRowInComponent:( NSInteger )component_
{
   return self.dash.dash;
}

-(void)pickerField:( PFPickerField* )picker_field_
      didSelectRow:( NSInteger )row_
       inComponent:( NSInteger )component_
{
   PFFrameView* frame_view_ = ( PFFrameView* )picker_field_.overlayView;
   UIImageView* image_view_ = ( UIImageView* )frame_view_.contentView;
   image_view_.image = [ self.availableLines objectAtIndex: row_ ];

   self.dash.dash = row_;

   [ super pickerField: picker_field_ didSelectRow: row_ inComponent: component_ ];
}

-(BOOL)pickerField:( PFPickerField* )picker_field_
 isCyclicComponent:( NSInteger )component_
{
   return NO;
}

@end
