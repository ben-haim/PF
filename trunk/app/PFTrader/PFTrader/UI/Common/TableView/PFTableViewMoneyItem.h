#import "PFTableViewItem.h"

#import <UIKit/UIKit.h>

@interface PFTableViewMoneyItem : PFTableViewItem

@property ( nonatomic, assign ) double amount;
@property ( nonatomic, strong ) NSString* currency;
@property ( nonatomic, assign ) BOOL colorSign;

-(id)initWithTitle:( NSString* )title_
            amount:( double )amount_
           currency:( NSString* )currency_
          colorSign:( BOOL )color_sign_;

+(id)itemWithTitle:( NSString* )title_
            amount:( double )amount_
          currency:( NSString* )currency_
         colorSign:( BOOL )color_sign_;

@end
