#import "PFCommissionGroup.h"

#import "PFMessage.h"
#import "PFField.h"
#import "PFMetaObject.h"

#import "PFCommission.h"
#import "PFCommissionInterval.h"

@implementation PFCommissionGroup

@synthesize type;
@synthesize paymentType;
@synthesize counterAccountId;
@synthesize activateIb;
@synthesize applyOperationType;
@synthesize currency;
@synthesize intervals;
@synthesize hasBuySellShort;

@synthesize value;

-(NSMutableArray*)value
{
   if ( !value )
      value = [ NSMutableArray new ];
   
   return value;
}

-(NSMutableArray*)intervals
{
   if ( !intervals )
     intervals = [NSMutableArray new];
   
   return intervals;
}

+(PFMetaObject*)metaObject
{
   return [ PFMetaObject metaObjectWithFields:
           @[[ PFMetaObjectField fieldWithId: PFFieldCommissionType name: @"type" ]
               , [ PFMetaObjectField fieldWithId: PFFieldCommissionPaymentType name: @"paymentType" ]
               , [ PFMetaObjectField fieldWithId: PFFieldCounterAccountId name: @"counterAccountId" ]
               , [ PFMetaObjectField fieldWithId: PFFieldCommissionActivateIb name: @"activateIb" ]
               , [ PFMetaObjectField fieldWithId: PFFieldApplyOpertionType name: @"applyOperationType" ]] ];
}

-(void)didUpdateWithFieldOwner:( PFFieldOwner* )field_owner_
{
   self.hasBuySellShort = NO;
   NSArray* value_groups_ = [ field_owner_ groupFieldsWithId: PFGroupCommissionValue ];
   
   for ( PFGroupField* value_group_ in value_groups_ )
   {
      PFCommission* value_ = [ PFCommission objectWithFieldOwner: value_group_.fieldOwner ];
      [ self.value addObject: value_ ];
   }
}

-(void)addCommissionGroupFrom: (PFCommissionGroup*)comm_group_
{
   for (PFCommission* value_ in comm_group_.value)
   {
      [self.value addObject: value_.copy];
   }
}

-(void)reproductionByBudding
{
   int lastPosition_ = 0;
   for (PFCommission* commission_ in value)
   {
      if (commission_.fromAmount == 0)
         continue;
      
      [self.intervals addObject: [[PFCommissionInterval new] initWithFrom: lastPosition_ andTo: commission_.fromAmount - 1]];
      lastPosition_ = commission_.fromAmount;
   }
   [self.intervals addObject: [[PFCommissionInterval new] initWithFrom: lastPosition_ andTo: -1]];
   
   for (PFCommission* commission_ in value)
   {
      for (PFCommissionInterval* commission_interval_ in intervals)
      {
         int from_ = commission_.fromAmount;
         int to_ = commission_.toAmount;
         
         if ((from_ <= commission_interval_.from) && ((to_ != -1) ? ((commission_interval_.to == -1) ? NO : (to_ >= commission_interval_.to)) : YES))
         {
            if (commission_.operationType == PFOperationTypeBySell)
            {
               self.hasBuySellShort = YES;
               [commission_interval_ addBuySellPrice: commission_.value];
            }
            else if (commission_.operationType == PFOperationTypeShort)
            {
               self.hasBuySellShort = YES;
               [commission_interval_ addShortPrice: commission_.value];
            }
            else if (commission_.operationType == PFOperationTypeAll)
            {
               [commission_interval_ addAllPrice: commission_.value];
            }
         }
      }
   }
}

-(NSString*)description
{
   return [ NSString stringWithFormat: @"PFCommissionGroup: commisionType=%d paymentType=%d counterAccountId=%d activateIb=%d applyOperationType=%@",
           self.type,
           self.paymentType,
           self.counterAccountId,
           self.activateIb,
           self.applyOperationType ];
}

@end
