#import "Detail/PFObject.h"

@interface PFCommissionInterval : NSObject

@property ( nonatomic, assign ) int from;
@property ( nonatomic, assign ) int to;
@property ( nonatomic, assign ) double allPrice;
@property ( nonatomic, assign ) double buySellPrice;
@property ( nonatomic, assign ) double shortPrice;

-(void)addAllPrice: (double) price_;
-(void)addBuySellPrice: (double) price_;
-(void)addShortPrice: (double) price_;
-(id)initWithFrom: (int)from andTo: (int)to;

@end
