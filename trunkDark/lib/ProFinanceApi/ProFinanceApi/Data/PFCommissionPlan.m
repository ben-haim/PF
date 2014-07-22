#import "PFCommissionPlan.h"

#import "PFMessage.h"
#import "PFField.h"
#import "PFMetaObject.h"

#import "PFCommissionLevelGroup.h"
#import "PFCommissionGroup.h"

#import "PFInstrument.h"
#import "PFInstrumentGroup.h"

@interface PFCommissionPlan ()

@property ( nonatomic, strong ) NSMutableArray* instrumentCommissionLevels;
@property ( nonatomic, strong ) NSMutableArray* instrumentGroupCommissionLevels;

@end

@implementation PFCommissionPlan

@synthesize name;
@synthesize description;
@synthesize counterAccountId;
@synthesize planId;
@synthesize comissionForTransfer;

@synthesize instrumentCommissionLevels;
@synthesize instrumentGroupCommissionLevels;

+(PFMetaObject*)metaObject
{
   return [ PFMetaObject metaObjectWithFields:
           [ NSArray arrayWithObjects:
              [ PFMetaObjectField fieldWithId: PFFieldCommissionPlanId name: @"planId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldName name: @"name" ]
            , [ PFMetaObjectField fieldWithId: PFFieldDescription name: @"description" ]
            , [ PFMetaObjectField fieldWithId: PFFieldCounterAccountId name: @"counterAccountId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldCommissionForTransferValue name: @"comissionForTransfer" ]
            , nil ] ];
}

-(void)didUpdateWithFieldOwner:( PFFieldOwner* )field_owner_
{
   NSArray* commission_level_groups_ = [ field_owner_ groupFieldsWithId: PFGroupCommissionLevel ];
   
   self.instrumentCommissionLevels = [ NSMutableArray new ];
   self.instrumentGroupCommissionLevels = [ NSMutableArray new ];
   
   for ( PFGroupField* comm_level_group_ in commission_level_groups_ )
   {
      PFCommissionLevelGroup* commission_level_ = [ PFCommissionLevelGroup objectWithFieldOwner: comm_level_group_.fieldOwner ];

//      if ( commission_level_.instrumentId > 0 )
//      {
         [ self.instrumentCommissionLevels addObject: commission_level_ ];
//      }
//      else
//      {
//         [ self.instrumentGroupCommissionLevels addObject: commission_level_ ];
//      }
   }
}

-(BOOL)isValid
{
   return (self.comissionForTransfer > 0.0);
}

-(NSArray*)commissionLevelForInstrument: ( id< PFInstrument > )instument_
{
//   PFCommissionGroup* curr_comm_level_ = [ self.instrumentCommissionLevels objectForKey: @(instument_.instrumentId) ];
//   
//   if ( !curr_comm_level_ )
//   {
//      if ( !( curr_comm_level_ = [ self.instrumentGroupCommissionLevels objectForKey: @(instument_.group.groupId) ] ) )
//      {
//         if ( !( curr_comm_level_ =  [ self.instrumentGroupCommissionLevels objectForKey: @(instument_.group.superId) ] ) )
//         {
//            curr_comm_level_ =  [ self.instrumentGroupCommissionLevels objectForKey: @(-1) ];
//         }
//      }
//   }
//   
//   return curr_comm_level_;
   
   NSMutableDictionary* commissions_entries_by_operation_type_ = [NSMutableDictionary new];
   
   for ( PFCommissionLevelGroup* comm_level_group_ in instrumentCommissionLevels )
   {
      if ((comm_level_group_.instrumentId != -1) && (comm_level_group_.instrumentId == instument_.instrumentId))
      {
         [ commissions_entries_by_operation_type_ setObject: comm_level_group_ forKey: @(comm_level_group_.type) ];
      }
      else
      {
         PFCommissionLevelGroup* curr_comm_level_ = [ commissions_entries_by_operation_type_ objectForKey: @(comm_level_group_.type) ];
         
         if ((comm_level_group_.instrumentTypeId != -1) && (comm_level_group_.instrumentTypeId == instument_.groupId)
             && (!curr_comm_level_ || ((curr_comm_level_.instrumentId == -1) && (curr_comm_level_.instrumentTypeId == -1))))
         {
            [ commissions_entries_by_operation_type_ setObject: comm_level_group_ forKey: @(comm_level_group_.type) ];
         }
         else if (!curr_comm_level_ && (comm_level_group_.instrumentId == -1) && (comm_level_group_.instrumentTypeId == -1))
         {
            [ commissions_entries_by_operation_type_ setObject: comm_level_group_ forKey: @(comm_level_group_.type) ];
         }
      }
   }
   

   NSMutableDictionary* comm_group_via_com_type_id_ = [NSMutableDictionary new];
   for (PFCommissionLevelGroup* comm_level_group_ in commissions_entries_by_operation_type_.allValues)
   {
      for (PFCommissionGroup* comm_group_ in comm_level_group_.commissionGroup)
      {
         PFCommissionGroup* comm_group_by_type_ = [comm_group_via_com_type_id_ objectForKey: @(comm_group_.type)];
         if (!comm_group_by_type_)
         {
            comm_group_by_type_ = [PFCommissionGroup new];
            [ comm_group_via_com_type_id_ setObject: comm_group_by_type_ forKey: @(comm_group_.type) ];
            comm_group_by_type_.type = comm_group_.type;
            comm_group_by_type_.paymentType = comm_group_.paymentType;
            comm_group_by_type_.currency = comm_level_group_.specifiedCurrency;
         }
         [comm_group_by_type_ addCommissionGroupFrom: comm_group_];
      }
   }
   
   NSArray* commissioncomm_group_collection = comm_group_via_com_type_id_.allValues;
   for (PFCommissionGroup* comm_group_ in commissioncomm_group_collection)
   {
      [comm_group_ reproductionByBudding];
   }
   
   return commissioncomm_group_collection;
}

-(NSString*)description
{
   return [ NSString stringWithFormat: @"PFCommissionPlan: planId=%d, name=%@, counterAccountId=%d, comissionForTransfer=%f"
           , self.planId
           , self.name
           , self.counterAccountId
           , self.comissionForTransfer ];
}

@end
