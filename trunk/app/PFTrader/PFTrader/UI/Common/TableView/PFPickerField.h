#import "PFBasePickerField.h"

#import <UIKit/UIKit.h>

@protocol PFPickerFieldDelegate;

@interface PFPickerField : PFBasePickerField

@property ( nonatomic, strong ) UIView* overlayView;

-(void)reloadData;

-(void)selectRow:( NSInteger )row_
     inComponent:( NSInteger )component_
        animated:( BOOL )animated_;

-(CGSize)rowSizeForComponent:( NSInteger )component_;

@end

@protocol PFPickerFieldDelegate <PFBasePickerFieldDelegate>

-(NSUInteger)pickerField:( PFPickerField* )picker_field_
 numberOfRowsInComponent:( NSInteger )component_;

-(NSString*)pickerField:( PFPickerField* )picker_field_
            titleForRow:( NSInteger )row_
           forComponent:( NSInteger )component_;

-(void)pickerField:( PFPickerField* )picker_field_
      didSelectRow:( NSInteger )row_
       inComponent:( NSInteger )component_;

@optional
-(UIView*)pickerField:( PFPickerField* )picker_field_
           viewForRow:( NSInteger )row_
         forComponent:( NSInteger )component_
          reusingView:( UIView* )view_;

-(NSUInteger)pickerField:( PFPickerField* )picker_field_
   currentRowInComponent:( NSInteger )component_;

-(NSUInteger)numberOfComponentsInPickerField:( PFPickerField* )picker_field_;

-(BOOL)pickerField:( PFPickerField* )picker_field_
 isCyclicComponent:( NSInteger )component_;

@end