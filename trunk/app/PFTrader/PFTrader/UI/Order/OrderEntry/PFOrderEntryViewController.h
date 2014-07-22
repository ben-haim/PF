#import "PFMarketOperationViewController.h"

#import <UIKit/UIKit.h>

@class PFTableView;
@class PFBuySellSelector;

@protocol PFSymbol;

@interface PFOrderEntryViewController : PFMarketOperationViewController

@property ( nonatomic, strong ) IBOutlet PFBuySellSelector* buySellSelector;
@property (strong, nonatomic) IBOutlet UIButton* placeButton;
@property (strong, nonatomic) IBOutlet UILabel* bidTextLabel;
@property (strong, nonatomic) IBOutlet UILabel* askTextLabel;

-(id)initWithSymbol:( id< PFSymbol > )symbol_;

-(id)initWithSymbol:( id< PFSymbol > )symbol_
      operationType:( PFMarketOperationType )operation_type_;

-(id)initWithLevel2Quote:( id< PFLevel2Quote > )level2_quote_
               andSymbol:( id< PFSymbol >)symbol_;

-(id)initWithLevel4Quote:( id< PFLevel4Quote > )level4_quote_ bidMode:( BOOL )bid_mode_;

-(IBAction)placeOrderAction:( id )sender_;

+(void)placeMarketOrderForSymbol:( id< PFSymbol > )symbol_ withAmount:( double )amount_ buyMode:( BOOL )buy_;

@end
