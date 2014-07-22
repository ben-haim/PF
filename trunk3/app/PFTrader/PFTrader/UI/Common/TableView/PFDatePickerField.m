#import "PFDatePickerField.h"

#import "NSDateFormatter+PFTrader.h"

@interface PFDatePickerField ()

@property ( nonatomic, strong, readonly ) UIDatePicker* datePicker;

@end

@implementation PFDatePickerField

@synthesize datePicker = _datePicker;
@synthesize date = _date;
@synthesize dateMode;
@synthesize fromTodayMode;

-(id< PFDatePickerFieldDelegate >)checkDelegate
{
   NSAssert( [ self.delegate conformsToProtocol: @protocol( PFDatePickerFieldDelegate ) ], @"delegate must conform PFPickerFieldDelegate protocol" );
   
   return ( id< PFDatePickerFieldDelegate > )self.delegate;
}

-(void)change
{
   self.date = self.datePicker.date;

   [ self.checkDelegate pickerField: self
                      didSelectDate: self.date ];
}

-(UIDatePicker*)datePicker
{
   if ( !_datePicker )
   {
      _datePicker = [ UIDatePicker new ];
      _datePicker.datePickerMode = self.dateMode;
      _datePicker.date = self.date ? self.date : [ NSDate date ];
       
       if ( self.fromTodayMode )
       {
           _datePicker.minimumDate = [ NSDate date ];
       }
       else
       {
           _datePicker.maximumDate = [ NSDate date ];
       }

      [ _datePicker addTarget: self
                       action: @selector( change )
             forControlEvents: UIControlEventValueChanged ];

      [ _datePicker sizeToFit ];
   }
   return _datePicker;
}

-(UIView*)inputView
{
   return self.datePicker;
}

-(void)setDate:( NSDate* )date_
{
   _date = date_;
   self.text = self.dateMode == UIDatePickerModeDateAndTime ?
   [ [ NSDateFormatter pickerDateFormatter ] stringFromDate: date_ ] :
   [ [ NSDateFormatter pickerDateOnlyFormatter ] stringFromDate: date_ ];
}

-(void)selectCurrentComponent
{
}

@end
