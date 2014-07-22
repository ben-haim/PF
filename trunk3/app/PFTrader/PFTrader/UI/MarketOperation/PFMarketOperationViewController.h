#import "PFTableViewController.h"

#import <ProFinanceApi/ProFinanceApi.h>

#import <UIKit/UIKit.h>

typedef void (^PFMarketOperationClosingBlock)();
typedef void (^PFMarketOperationConfirmBlock)();

@class PFTableView;
@class PFTableViewCategory;

@protocol PFSymbol;

@interface PFMarketOperationViewController : PFTableViewController

@property(nonatomic,copy) PFMarketOperationClosingBlock closingBlock;

@property ( nonatomic, strong ) IBOutlet PFTableView* tableView;

@property ( nonatomic, strong ) IBOutlet UILabel* nameLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* overviewLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* bidLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* askLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* bidTitleLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* askTitleLabel;

@property ( nonatomic, strong, readonly ) id< PFSymbol > symbol;
@property ( nonatomic, assign, readonly ) PFDouble defaultPrice;
@property ( nonatomic, assign, readonly ) PFDouble defaultSLTPPrice;
@property ( nonatomic, assign, readonly ) BOOL useOffsetMode;
@property ( nonatomic, assign ) BOOL OCOMode;

@property ( nonatomic, strong ) PFTableViewCategory* accountCategory;
@property ( nonatomic, strong ) PFTableViewCategory* orderTypeCategory;
@property ( nonatomic, strong ) PFTableViewCategory* quantityCategory;
@property ( nonatomic, strong ) PFTableViewCategory* validityCategory;
@property ( nonatomic, strong ) PFTableViewCategory* slCategory;
@property ( nonatomic, strong ) PFTableViewCategory* tpCategory;

-(id)initWithTitle:( NSString* )title_
            symbol:( id< PFSymbol > )symbol_;

-(void)remove;
-(void)close;
-(void)showOrders;
-(void)showPositions;

-(void)updateButtonsVisibility;
-(void)showControllerWithController:( UIViewController* )controller_;
-(double)priceLimitForOperation:( id<PFMarketOperation> )market_operation_ andSLMode:( BOOL )is_sl_;
-(BOOL)checkSLTPForMarketOperation:( id<PFMarketOperation> )market_operation_;

+(void)showConfirmWithText:( NSString* )text_
                actionText:( NSString* )action_text_
        confirmActionBlock:( PFMarketOperationConfirmBlock )block_;

@end
