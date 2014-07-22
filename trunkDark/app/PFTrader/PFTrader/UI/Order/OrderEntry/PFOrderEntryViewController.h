#import "PFMarketOperationViewController.h"

#import <UIKit/UIKit.h>

@class PFTableView;
@protocol PFSymbol;

@interface PFOrderEntryViewController : PFMarketOperationViewController

@property ( nonatomic, weak ) IBOutlet UIButton* placeBuyButton;
@property ( nonatomic, weak ) IBOutlet UIButton* placeSellButton;
@property ( nonatomic, weak ) IBOutlet UILabel* bidTextLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* askTextLabel;

+(void)showWithSymbol:( id< PFSymbol > )symbol_;
+(void)showWithLevel4Quote:( id< PFLevel4Quote > )level4_quote_;
+(void)showWithLevel2Quote:( id< PFLevel2Quote > )level2_quote_
                 andSymbol:( id< PFSymbol >)symbol_;

-(IBAction)placeBuyOrderAction:( id )sender_;
-(IBAction)placeSellOrderAction:( id )sender_;

+(void)placeMarketOrderForSymbol:( id< PFSymbol > )symbol_
                      withAmount:( double )amount_
                         buyMode:( BOOL )buy_;

@end
