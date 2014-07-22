#import "PFConcreteGridCell.h"

#import "UIView+LoadFromNib.h"

#import "NSDate+Timestamp.h"
#import "NSString+DoubleFormatter.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFConcreteGridCell ()< PFSessionDelegate >

@property ( nonatomic, strong ) id< PFMarketOperation > currentOperation;

@property ( nonatomic, strong ) id< PFSymbol > currentSymbol;
@property ( nonatomic, strong ) id< PFLevel2Quote > currentLevel2Quote;
@property ( nonatomic, strong ) id< PFLevel4Quote > currentLevel4Quote;

@end

@implementation PFConcreteGridCell

@synthesize currentSymbol;
@synthesize currentOperation;
@synthesize currentLevel2Quote;
@synthesize currentLevel4Quote;

@dynamic symbol;
@dynamic order;
@dynamic position;
@dynamic trade;

//!Workaround for assign delegate
-(void)dealloc
{
   [ self unsubscribeSession ];
}

-(void)subscribeSessionIfNeeded
{
   if ( self.isDynamic )
   {
      [ [ PFSession sharedSession ] addDelegate: self ];
   }
}

-(void)unsubscribeSession
{
   [ [ PFSession sharedSession ] removeDelegate: self ];
}

+(NSString*)nibName
{
   return NSStringFromClass( self );
}

+(NSString*)reuseIdentifier
{
   return NSStringFromClass( self );
}

-(NSString*)reuseIdentifier
{
   return [ [ self class ] reuseIdentifier ];
}

-(BOOL)isDynamic
{
   if ( self.symbol )
      return NO;

   return YES;
}

-(void)prepareForEnqueue
{
   [ self unsubscribeSession ];
}

-(void)prepareForDequeue
{
   [ self subscribeSessionIfNeeded ];
}

+(id)cell
{
   PFConcreteGridCell* cell_ = [ self viewAsFileOwnerFromNibNamed: [ self nibName ] ];
   [ cell_ subscribeSessionIfNeeded ];
   return cell_;
}

-(id<PFSymbol>)symbol
{
   return self.currentSymbol;
}

-(id<PFOrder>)order
{
   return PFMarketOperationAsOrder( self.currentOperation );
}

-(id<PFPosition>)position
{
   return PFMarketOperationAsPosition( self.currentOperation );
}

-(id<PFTrade>)trade
{
   return PFMarketOperationAsTrade( self.currentOperation );
}

-(id<PFLevel2Quote>)level2Quote
{
   return self.currentLevel2Quote;
}

-(id<PFLevel4Quote>)level4Quote
{
   return self.currentLevel4Quote;
}

-(void)reloadDataWithSymbol:( id< PFSymbol > )symbol_
{
}

-(void)reloadDataWithMarketOperation:( id< PFMarketOperation > )operation_
{
   [ self reloadDataWithSymbol: operation_.symbol ];
}

-(void)reloadDataWithOrder:( id< PFOrder > )order_
{
   [ self reloadDataWithMarketOperation: order_ ];
}

-(void)reloadDataWithPosition:( id< PFPosition > )position_
{
   [ self reloadDataWithMarketOperation: position_ ];
}

-(void)reloadDataWithTrade:( id< PFTrade > )trade_
{
   [ self reloadDataWithMarketOperation: trade_ ];
}

-(void)reloadDataWithLevel2Quote:( id< PFLevel2Quote > )level2_quote_
{
}

-(void)reloadDataWithLevel4Quote:( id< PFLevel4Quote > )level4_quote_
{
}

-(void)setSymbol:( id< PFSymbol > )symbol_
{
   self.currentSymbol = symbol_;
   [ self reloadDataWithSymbol: symbol_ ];
}

-(void)setPosition:( id< PFPosition > )position_
{
   self.currentOperation = position_;
   [ self reloadDataWithPosition: position_ ];
}

-(void)setOrder:( id< PFOrder > )order_
{
   self.currentOperation = order_;
   [ self reloadDataWithOrder: order_ ];
}

-(void)setTrade:( id< PFTrade > )trade_
{
   self.currentOperation = trade_;
   [ self reloadDataWithTrade: trade_ ];
}

-(void)setLevel2Quote:( id< PFLevel2Quote > )level2_quote_
{
   self.currentLevel2Quote = level2_quote_;
   [ self reloadDataWithLevel2Quote: level2_quote_ ];
}

-(void)setLevel4Quote:( id< PFLevel4Quote > )level4_quote_
{
   self.currentLevel4Quote = level4_quote_;
   [ self reloadDataWithLevel4Quote: level4_quote_ ];
}

-(void)update
{
   if ( self.symbol )
   {
      [ self reloadDataWithSymbol: self.symbol ];
   }
   else if ( self.position )
   {
      [ self reloadDataWithPosition: self.position ];
   }
   else if ( self.order )
   {
      [ self reloadDataWithOrder: self.order ];
   }
   else if ( self.trade )
   {
      [ self reloadDataWithTrade: self.trade ];
   }
   else if ( self.level2Quote )
   {
      [ self reloadDataWithLevel2Quote: self.level2Quote ];
   }
   else if ( self.level4Quote )
   {
      [ self reloadDataWithLevel4Quote: self.level4Quote ];
   }
}

-(void)session:( PFSession* )session_
didUpdatePosition:( id< PFPosition > )position_
          type:( PFPositionUpdateType )type_
{
   if ( [ self.position isEqual: position_ ] )
   {
      [ self reloadDataWithPosition: position_ ];
   }
}

-(void)session:( PFSession* )session_
didUpdateOrder:( id< PFOrder > )order_
{
   if ( [ self.order isEqual: order_ ] )
   {
      [ self reloadDataWithOrder: order_ ];
   }
}

@end

/////////////////////////////////////////////////////

@implementation PFNameCell

@synthesize nameLabel;
@synthesize overviewLabel;

-(BOOL)isDynamic
{
   return NO;
}

-(void)reloadDataWithTopText:( NSString* )top_
                  bottomText:( NSString* )bottom_
{
   self.nameLabel.text = top_;
   self.overviewLabel.text = bottom_;

   CGRect name_rect_ = self.nameLabel.frame;

   if ( [ bottom_ length ] == 0 )
   {
      name_rect_.size.height = CGRectGetMaxY( self.overviewLabel.frame ) - CGRectGetMinY( name_rect_ );
   }
   else
   {
      name_rect_.size.height = CGRectGetMinY( self.overviewLabel.frame ) - CGRectGetMinY( name_rect_ );
   }

   self.nameLabel.frame = name_rect_;
}


-(void)reloadDataWithSymbol:( id< PFSymbol > )symbol_
{
   [ self reloadDataWithTopText: symbol_.name
                     bottomText: symbol_.instrument.overview ];
}

-(void)reloadDataWithMarketOperation:( id< PFMarketOperation > )operation_
{
   [ self reloadDataWithTopText: operation_.symbol.name
                     bottomText: [ operation_.createdAt shortTimestampString ] ];
}

-(void)reloadDataWithLevel4Quote:( id<PFLevel4Quote> )level4_quote_
{
   [ self reloadDataWithTopText: [ NSString stringWithDouble: level4_quote_.strikePrice
                                                   precision: level4_quote_.symbol.instrument.precision ]
                     bottomText: nil ];
}

@end

/////////////////////////////////////////////////////

@implementation PFValueCell

@synthesize valueLabel;

+(NSString*)nibName
{
   return NSStringFromClass( [ PFValueCell class ] );
}

@end

/////////////////////////////////////////////////////

@implementation PFPriceCell

+(NSString*)nibName
{
   return NSStringFromClass( [ PFPriceCell class ] );
}

@end

/////////////////////////////////////////////////////

@implementation PFDetailCell

@synthesize topLabel;
@synthesize bottomLabel;

+(NSString*)nibName
{
   return NSStringFromClass( [ PFDetailCell class ] );
}

@end

/////////////////////////////////////////////////////

@implementation NSObject (PFConcreteGridCell)

-(void)assignToCell:( PFConcreteGridCell* )cell_
{
}

-(void)updateWithCell:( PFConcreteGridCell* )cell_
{
}

@end

@implementation PFSymbol (PFConcreteGridCell)

-(void)assignToCell:( PFConcreteGridCell* )cell_
{
   cell_.symbol = self;
}

-(void)updateWithCell:( PFConcreteGridCell* )cell_
{
   [ cell_ reloadDataWithSymbol: self ];
}

@end

@implementation PFPosition (PFConcreteGridCell)

-(void)assignToCell:( PFConcreteGridCell* )cell_
{
   cell_.position = self;
}

-(void)updateWithCell:( PFConcreteGridCell* )cell_
{
   [ cell_ reloadDataWithPosition: self ];
}

@end

@implementation PFOrder (PFConcreteGridCell)

-(void)assignToCell:( PFConcreteGridCell* )cell_
{
   cell_.order = self;
}

-(void)updateWithCell:( PFConcreteGridCell* )cell_
{
   [ cell_ reloadDataWithOrder: self ];
}

@end

@implementation PFTrade (PFConcreteGridCell)

-(void)assignToCell:( PFConcreteGridCell* )cell_
{
   cell_.trade = self;
}

-(void)updateWithCell:( PFConcreteGridCell* )cell_
{
   [ cell_ reloadDataWithTrade: self ];
}

@end

@implementation PFLevel2Quote (PFConcreteGridCell)

-(void)assignToCell:( PFConcreteGridCell* )cell_
{
   cell_.level2Quote = self;
}

-(void)updateWithCell:( PFConcreteGridCell* )cell_
{
   [ cell_ reloadDataWithLevel2Quote: self ];
}

@end

@implementation PFLevel4Quote (PFConcreteGridCell)

-(void)assignToCell:( PFConcreteGridCell* )cell_
{
   cell_.level4Quote = self;
}

-(void)updateWithCell:( PFConcreteGridCell* )cell_
{
   [ cell_ reloadDataWithLevel4Quote: self ];
}

@end
