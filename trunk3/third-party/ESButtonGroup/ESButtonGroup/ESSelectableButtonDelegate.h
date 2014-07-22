#import <Foundation/Foundation.h>

@class ESSelectableButton;

@protocol ESSelectableButtonDelegate< NSObject >

-(void)buttonDidChangeState:( ESSelectableButton* )button_;

@optional
-(BOOL)disableChangeStateForButton:( ESSelectableButton* )button_;

@end

@interface NSObject (ESSelectableButtonDelegate)

@end

