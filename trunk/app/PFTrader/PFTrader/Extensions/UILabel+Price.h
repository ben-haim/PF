#import <UIKit/UIKit.h>

#import <ProFinanceApi/ProFinanceApi.h>

@protocol PFSymbol;

@interface UILabel (Price)

-(void)showAskForSymbol:( id< PFSymbol > )symbol_;
-(void)showBidForSymbol:( id< PFSymbol > )symbol_;
-(void)showLastForSymbol:( id< PFSymbol > )symbol_;

-(void)showPrice:( PFDouble )price_
       forSymbol:( id< PFSymbol > )symbol_;

-(void)showPrice:( PFDouble )price_
       forSymbol:( id< PFSymbol > )symbol_
        coloured:( BOOL )coloured_;

-(void)showColouredValue:( double )value_
               precision:( NSUInteger )precision_;

-(void)showColouredValue:( double )value_
               precision:( NSUInteger )precision_
                  suffix: (NSString*)suffix_;

@end
