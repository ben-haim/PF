#import "PFTableViewPickerItem.h"

#import <ProFinanceApi/ProFinanceApi.h>

#import <UIKit/UIKit.h>

@protocol PFSymbol;

@interface PFTableViewPriceItem : PFTableViewPickerItem

@property ( nonatomic, assign, readonly ) PFDouble price;

-(id)initWithTitle:( NSString* )title_
            symbol:( id< PFSymbol > )symbol_
             price:( PFDouble )price_;

+(id)itemWithTitle:( NSString* )title_
            symbol:( id< PFSymbol > )symbol_
             price:( PFDouble )price_;

@end
