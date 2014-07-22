#import "PFPickerField.h"

#import "PFRound.h"

@protocol PFPickerFieldRowManager <NSObject>

-(NSUInteger)convertPickerRow:( NSUInteger )picker_row_;

-(NSUInteger)convertNumberOfRows:( NSUInteger )rows_count_;

-(NSUInteger)convertCurrentRow:( NSUInteger )current_row_;

-(NSUInteger)convertSelectedRow:( NSUInteger )selected_row_
                     currentRow:( NSUInteger )current_row_;

@end

@interface PFPickerFieldCyclicRowManager : NSObject< PFPickerFieldRowManager >

@property ( nonatomic, assign ) NSUInteger count;
@property ( nonatomic, assign ) NSUInteger multiplier;

-(id)initWithCount:( NSUInteger )count_;

@end

@implementation PFPickerFieldCyclicRowManager

@synthesize count;
@synthesize multiplier;

-(id)initWithCount:( NSUInteger )count_
{
   self = [ super init ];
   if ( self )
   {
      self.count = count_;
      self.multiplier = fmin( fmax( 1.0, 1000.0 / self.count ), 10.0 );
   }
   return self;
}

-(NSUInteger)convertNumberOfRows:( NSUInteger )rows_count_
{
   return self.multiplier * rows_count_;
}

-(NSUInteger)convertPickerRow:( NSUInteger )picker_row_
{
   return picker_row_ % self.count;
}

-(NSUInteger)convertCurrentRow:( NSUInteger )current_row_
{
   return floor(self.multiplier / 2 ) * self.count + current_row_;
}

-(NSUInteger)convertSelectedRow:( NSUInteger )selected_row_
                     currentRow:( NSUInteger )current_row_
{
   NSUInteger cycle_index_ = current_row_ / self.count;
   return cycle_index_ * self.count + selected_row_;
}

@end

@interface PFPickerFieldAsIsRowManager : NSObject< PFPickerFieldRowManager >

@end

@implementation PFPickerFieldAsIsRowManager

-(NSUInteger)convertNumberOfRows:( NSUInteger )rows_count_
{
   return rows_count_;
}

-(NSUInteger)convertPickerRow:( NSUInteger )picker_row_
{
   return picker_row_;
}

-(NSUInteger)convertCurrentRow:( NSUInteger )current_row_
{
   return current_row_;
}

-(NSUInteger)convertSelectedRow:( NSUInteger )selected_row_
                     currentRow:( NSUInteger )current_row_
{
   return selected_row_;
}

@end

@interface PFPickerField ()< UIPickerViewDelegate, UIPickerViewDataSource >

@property ( nonatomic, strong, readonly ) UIPickerView* pickerView;

@property ( nonatomic, strong ) NSArray* rowManagers;

@end

@implementation PFPickerField

@synthesize overlayView = _overlayView;
@synthesize pickerView = _pickerView;
@synthesize rowManagers = _rowManagers;
@synthesize delegate;

-(void)setOverlayView:( UIView* )overlay_view_
{
   if ( overlay_view_ != _overlayView )
   {
      [ _overlayView removeFromSuperview ];

      overlay_view_.userInteractionEnabled = NO;
      overlay_view_.frame = self.bounds;
      overlay_view_.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
      [ self addSubview: overlay_view_ ];
      [ self bringSubviewToFront: overlay_view_ ];

      _overlayView = overlay_view_;
   }
}

-(id< PFPickerFieldDelegate >)checkDelegate
{
   NSAssert( [ self.delegate conformsToProtocol: @protocol( PFPickerFieldDelegate ) ], @"delegate must conform PFPickerFieldDelegate protocol" );

   return ( id< PFPickerFieldDelegate > )self.delegate;
}

-(NSArray*)rowManagers
{
   if ( !_rowManagers )
   {
      NSUInteger number_of_components_ = [ self.checkDelegate numberOfComponentsInPickerField: self ];
      
      NSMutableArray* managers_ = [ NSMutableArray arrayWithCapacity: number_of_components_ ];
      
      for ( NSUInteger component_ = 0; component_ < number_of_components_; ++component_ )
      {
         BOOL is_cyclic_ = [ self.checkDelegate pickerField: self isCyclicComponent: component_ ];
         
         if ( is_cyclic_ )
         {
            NSUInteger rows_count_ = [ self.checkDelegate pickerField: self numberOfRowsInComponent: component_ ];
            [ managers_ addObject: [ [ PFPickerFieldCyclicRowManager alloc ] initWithCount: rows_count_ ] ];
         }
         else
         {
            [ managers_ addObject: [ PFPickerFieldAsIsRowManager new ] ];
         }
      }

      _rowManagers = managers_;
   }

   return _rowManagers;
}

-(UIPickerView*)pickerView
{
   if ( !_pickerView )
   {
      _pickerView = [ UIPickerView new ];
      [ _pickerView sizeToFit ];
      _pickerView.showsSelectionIndicator = YES;
      _pickerView.backgroundColor = [ UIColor darkGrayColor ];
   }
   return _pickerView;
}

-(UIView*)inputView
{
   return self.pickerView;
}

-(void)reloadData
{
   [ super reloadData ];

   self.overlayView = nil;

   self.rowManagers = nil;

   self.pickerView.delegate = self;
   self.pickerView.dataSource = self;

   [ self.pickerView reloadAllComponents ];
}

-(void)selectRow:( NSInteger )row_
     inComponent:( NSInteger )component_
        animated:( BOOL )animated_
{
   id< PFPickerFieldRowManager > row_manager_ = [ self.rowManagers objectAtIndex: component_ ];

   NSUInteger picker_row_ = [ row_manager_ convertSelectedRow: row_
                                                   currentRow: [ self.pickerView selectedRowInComponent: component_ ] ];

   [ self.pickerView selectRow: picker_row_
                   inComponent: component_
                      animated: animated_ ];
}

-(CGSize)rowSizeForComponent:( NSInteger )component_
{
   return [ self.pickerView rowSizeForComponent: component_ ];
}

-(NSInteger)numberOfComponentsInPickerView:( UIPickerView* )picker_view_
{
   return [ self.checkDelegate numberOfComponentsInPickerField: self ];
}

-(NSInteger)pickerView:( UIPickerView* )picker_view_
numberOfRowsInComponent:( NSInteger )component_
{
   NSUInteger number_of_rows_ = [ self.checkDelegate pickerField: self
                                         numberOfRowsInComponent: component_ ];

   return [ [ self.rowManagers objectAtIndex: component_ ] convertNumberOfRows: number_of_rows_ ];
}

-(NSString*)pickerView:( UIPickerView* )picker_view_
           titleForRow:( NSInteger )row_
          forComponent:( NSInteger )component_
{
   NSInteger selected_row_ = [ [ self.rowManagers objectAtIndex: component_ ] convertPickerRow: row_ ];

   return [ self.checkDelegate pickerField: self
                               titleForRow: selected_row_
                              forComponent: component_ ];
}

-(UIView*)pickerView:( UIPickerView* )picker_view_
          viewForRow:( NSInteger )row_
        forComponent:( NSInteger )component_
         reusingView:( UIView* )view_
{
   NSInteger selected_row_ = [ [ self.rowManagers objectAtIndex: component_ ] convertPickerRow: row_ ];

   return [ self.checkDelegate pickerField: self
                                viewForRow: selected_row_
                              forComponent: component_
                               reusingView: view_ ];
}

-(void)pickerView:( UIPickerView* )picker_view_
     didSelectRow:( NSInteger )row_
      inComponent:( NSInteger )component_
{
   NSInteger selected_row_ = [ [ self.rowManagers objectAtIndex: component_ ] convertPickerRow: row_ ];

   [ self.checkDelegate pickerField: self
                       didSelectRow: selected_row_
                        inComponent: component_ ];
}

-(void)selectCurrentComponent
{
   for ( NSUInteger component_ = 0; component_ < self.pickerView.numberOfComponents; ++component_ )
   {
      NSInteger current_row_ = [ [ self.rowManagers objectAtIndex: component_ ] convertCurrentRow: [ self.checkDelegate pickerField: self currentRowInComponent: component_ ] ];
      
      [ self.pickerView selectRow: current_row_
                      inComponent: component_
                         animated: NO ];
   }
}

-(BOOL)becomeFirstResponder
{
   BOOL become_first_responder_ = [ super becomeFirstResponder ];
   if ( become_first_responder_ )
   {
      [ self selectCurrentComponent ];
   }

   return become_first_responder_;
}

@end

@implementation NSObject (PFPickerFieldDelegate)

-(NSUInteger)pickerField:( PFPickerField* )picker_field_
   currentRowInComponent:( NSInteger )component_
{
   return 0;
}

-(NSUInteger)numberOfComponentsInPickerField:( PFPickerField* )picker_field_
{
   return 1;
}

-(BOOL)pickerField:( PFPickerField* )picker_field_
 isCyclicComponent:( NSInteger )component_
{
   return NO;
}

-(UIView*)pickerField:( PFPickerField* )picker_field_
           viewForRow:( NSInteger )row_
         forComponent:( NSInteger )component_
          reusingView:( UIView* )view_
{
   UILabel* label_ = ( UILabel* )view_;

   if ( !label_ )
   {
      CGRect label_rect_ = CGRectZero;
      label_rect_.size = [ picker_field_ rowSizeForComponent: component_ ];
      label_ = [ [ UILabel alloc ] initWithFrame: label_rect_ ];
      label_.font = [ UIFont boldSystemFontOfSize: 16.f ];
      label_.textAlignment = NSTextAlignmentCenter;
      label_.backgroundColor = [ UIColor clearColor ];
   }

   label_.text = [ picker_field_.checkDelegate pickerField: picker_field_
                                               titleForRow: row_
                                              forComponent: component_ ];

   return label_;
}

@end
