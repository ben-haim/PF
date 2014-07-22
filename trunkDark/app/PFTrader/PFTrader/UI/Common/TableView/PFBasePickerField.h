#import <UIKit/UIKit.h>

@protocol PFBasePickerFieldDelegate;

@interface PFBasePickerField : UIView

@property ( nonatomic, strong ) NSString* text;

@property ( nonatomic, strong, readonly ) UIView* inputView;
@property ( nonatomic, unsafe_unretained ) id< PFBasePickerFieldDelegate > delegate;
@property ( nonatomic, assign ) BOOL hiddenDoneButton;

-(void)reloadData;
-(void)selectCurrentComponent;

@end

@protocol PFBasePickerFieldDelegate <NSObject>

@optional
-(NSArray*)accessoryItemsInPickerField:( PFBasePickerField* )picker_field_;

@end
