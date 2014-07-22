#import "Detail/PFObject.h"

typedef enum
{
   PFOperationTypeAll = 0,
   PFOperationTypeBySell = 1,
   PFOperationTypeShort = 2
} PFOperationType;

@protocol PFCommission < NSObject >

-(PFOperationType)operationType;
-(PFInteger)fromAmount;
-(PFInteger)toAmount;
-(PFDouble)value;

@end

@interface PFCommission : PFObject < PFCommission >

@property ( nonatomic, assign ) PFOperationType operationType;
@property ( nonatomic, assign ) PFInteger fromAmount;
@property ( nonatomic, assign ) PFInteger toAmount;
@property ( nonatomic, assign ) PFDouble value;

@end
