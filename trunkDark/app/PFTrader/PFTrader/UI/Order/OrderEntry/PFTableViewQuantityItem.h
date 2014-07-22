#import "PFTableViewPickerItem.h"

#import <UIKit/UIKit.h>

@protocol PFSymbol;

@interface PFTableViewQuantityItem : PFTableViewPickerItem

@property ( nonatomic, assign, readonly ) double lots;

-(id)initWithSymbol:( id< PFSymbol > )symbol_;

-(id)initWithSymbol:( id< PFSymbol > )symbol_
               lots:( double )lots_;

-(id)initWithLots:( double )lots_;

@end
