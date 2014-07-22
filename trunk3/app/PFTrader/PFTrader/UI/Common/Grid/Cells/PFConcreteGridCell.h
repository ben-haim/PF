#import "PFGridCell.h"

#import <UIKit/UIKit.h>

@protocol PFSymbol;
@protocol PFMarketOperation;
@protocol PFPosition;
@protocol PFOrder;
@protocol PFTrade;
@protocol PFLevel2Quote;
@protocol PFLevel4Quote;

@interface PFConcreteGridCell : PFGridCell

@property ( nonatomic, strong ) id< PFSymbol > symbol;
@property ( nonatomic, strong ) id< PFPosition > position;
@property ( nonatomic, strong ) id< PFOrder > order;
@property ( nonatomic, strong ) id< PFTrade > trade;
@property ( nonatomic, strong ) id< PFLevel2Quote > level2Quote;
@property ( nonatomic, strong ) id< PFLevel4Quote > level4Quote;

+(id)cell;

+(NSString*)reuseIdentifier;

-(void)reloadDataWithSymbol:( id< PFSymbol > )symbol_;
-(void)reloadDataWithMarketOperation:( id< PFMarketOperation > )operation_;
-(void)reloadDataWithOrder:( id< PFOrder > )order_;
-(void)reloadDataWithPosition:( id< PFPosition > )position_;
-(void)reloadDataWithTrade:( id< PFTrade > )trade_;
-(void)reloadDataWithLevel2Quote:( id< PFLevel2Quote > )level2_quote_;
-(void)reloadDataWithLevel4Quote:( id< PFLevel4Quote > )level4_quote_;

@end

@interface PFNameCell : PFConcreteGridCell

@property ( nonatomic, strong ) IBOutlet UILabel* nameLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* overviewLabel;

@end

@interface PFValueCell : PFConcreteGridCell

@property ( nonatomic, strong ) IBOutlet UILabel* valueLabel;

@end

@interface PFPriceCell : PFValueCell

@end

@interface PFDetailCell : PFConcreteGridCell

@property ( nonatomic, strong ) IBOutlet UILabel* topLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* bottomLabel;

@end

@interface NSObject (PFConcreteGridCell)

-(void)assignToCell:( PFConcreteGridCell* )cell_;

@end
