#import "PFMarketOperationViewController.h"

#import <UIKit/UIKit.h>

@class PFTableView;

@protocol PFSymbol;

@interface PFOrderEntryViewController : PFMarketOperationViewController

@property (strong, nonatomic) IBOutlet UIButton* placeBuyButton;
@property (strong, nonatomic) IBOutlet UIButton* placeSellButton;
@property (strong, nonatomic) IBOutlet UILabel* bidTextLabel;
@property (strong, nonatomic) IBOutlet UILabel* askTextLabel;

-(id)initWithSymbol:( id< PFSymbol > )symbol_;

-(id)initWithLevel2Quote:( id< PFLevel2Quote > )level2_quote_
               andSymbol:( id< PFSymbol >)symbol_;

-(id)initWithLevel4Quote:( id< PFLevel4Quote > )level4_quote_;

-(IBAction)placeBuyOrderAction:( id )sender_;
-(IBAction)placeSellOrderAction:( id )sender_;

+(void)placeMarketOrderForSymbol:( id< PFSymbol > )symbol_
                      withAmount:( double )amount_
                         buyMode:( BOOL )buy_;

@end
