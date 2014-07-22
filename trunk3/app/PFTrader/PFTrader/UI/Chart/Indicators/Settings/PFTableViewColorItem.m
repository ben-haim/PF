#import "PFTableViewColorItem.h"

#import "PFIndicator.h"

#import "PFFrameView.h"

#import "UIColor+FromInt.h"

@interface PFTableViewColorItem ()

@property ( nonatomic, strong ) PFIndicatorAttributeColor* color;

@property ( nonatomic, strong ) NSArray* availableColors;

@end

@implementation PFTableViewColorItem

@synthesize color;
@synthesize availableColors;

-(id)initWithColor:( PFIndicatorAttributeColor* )color_
{
   self = [ super initWithAction: nil title: color_.title ];
   if ( self )
   {
      self.color = color_;
      self.availableColors = @[ @(0xff0000ff)
      , @(0x00ff00ff)
      , @(0x0000ffff)
      , @(0x777777ff)
      , @(0x123456ff)
      ];
   }
   return self;
}

-(void)updatePickerField:( PFPickerField* )picker_field_
{
   PFFrameView* frame_view_ = [ PFFrameView new ];
   frame_view_.color = [ UIColor colorWithInteger: self.color.colorValue ];
   picker_field_.overlayView = frame_view_;
}

-(NSUInteger)pickerField:( PFPickerField* )picker_field_
 numberOfRowsInComponent:( NSInteger )component_
{
   return [ self.availableColors count ];
}

-(UIColor*)colorForRow:( NSInteger )row_
{
   return [ UIColor colorWithInteger: [ [ self.availableColors objectAtIndex: row_ ] unsignedIntValue ] ];
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
      frame_view_ = [ [ PFFrameView alloc ] initWithFrame: CGRectInset( view_rect_, 60.f, 5.f ) ];
      frame_view_.color = [ UIColor whiteColor ];
   }

   frame_view_.contentView.backgroundColor = [ self colorForRow: row_ ];

   return frame_view_;
}

-(NSUInteger)pickerField:( PFPickerField* )picker_field_
   currentRowInComponent:( NSInteger )component_
{
   NSInteger index_ = [ self.availableColors indexOfObject: @(self.color.colorValue) ];
   return index_ == NSNotFound ? 0 : index_;
}

-(void)pickerField:( PFPickerField* )picker_field_
      didSelectRow:( NSInteger )row_
       inComponent:( NSInteger )component_
{
   PFFrameView* frame_view_ = ( PFFrameView* )picker_field_.overlayView;
   frame_view_.color = [ self colorForRow: row_ ];

   self.color.colorValue = [ [ self.availableColors objectAtIndex: row_ ] unsignedIntValue ];

   [ super pickerField: picker_field_ didSelectRow: row_ inComponent: component_ ];
}

-(BOOL)pickerField:( PFPickerField* )picker_field_
 isCyclicComponent:( NSInteger )component_
{
   return NO;
}

@end
