#import "PFSpreadPlan.h"

#import "PFMessage.h"
#import "PFField.h"
#import "PFMetaObject.h"

#import "PFSpreadLevel.h"
#import "PFCommissionLevel.h"

#import "PFInstrument.h"
#import "PFInstrumentGroup.h"

@interface PFSpreadPlan ()

@property ( nonatomic, strong ) NSMutableDictionary* instrumentSpreadLevels;
@property ( nonatomic, strong ) NSMutableDictionary* instrumentGroupSpreadLevels;
@property ( nonatomic, strong ) NSMutableDictionary* instrumentCommissionLevels;
@property ( nonatomic, strong ) NSMutableDictionary* instrumentGroupCommissionLevels;

@end

@implementation PFSpreadPlan

@synthesize planId;
@synthesize specifiedCurrency;
@synthesize instrumentSpreadLevels;
@synthesize instrumentGroupSpreadLevels;
@synthesize instrumentCommissionLevels;
@synthesize instrumentGroupCommissionLevels;

+(PFMetaObject*)metaObject
{
   return [ PFMetaObject metaObjectWithFields:
           [ NSArray arrayWithObjects: [ PFMetaObjectField fieldWithId: PFFieldCommissionPlanId name: @"planId" ]
            ,[ PFMetaObjectField fieldWithId: PFFieldCurrency name: @"specifiedCurrency" ]
            , nil ] ];
}

-(void)didUpdateWithFieldOwner:( PFFieldOwner* )field_owner_
{
   NSArray* spread_level_groups_ = [ field_owner_ groupFieldsWithId: PFGroupSpreadLevel ];
   
   self.instrumentSpreadLevels = [ NSMutableDictionary new ];
   self.instrumentGroupSpreadLevels = [ NSMutableDictionary new ];
   
   for ( PFGroupField* spread_level_group_ in spread_level_groups_ )
   {
      PFSpreadLevel* spread_level_ = [ PFSpreadLevel objectWithFieldOwner: spread_level_group_.fieldOwner ];
      
      if ( spread_level_.instrumentId > 0 )
      {
         [ self.instrumentSpreadLevels setObject: spread_level_ forKey: @(spread_level_.instrumentId)  ];
      }
      else
      {
         [ self.instrumentGroupSpreadLevels setObject: spread_level_ forKey: @(spread_level_.instrumentTypeId)  ];
      }
   }
   
   NSArray* commission_level_groups_ = [ field_owner_ groupFieldsWithId: PFGroupCommissionLevel ];
   
   self.instrumentCommissionLevels = [ NSMutableDictionary new ];
   self.instrumentGroupCommissionLevels = [ NSMutableDictionary new ];
   
   for ( PFGroupField* commission_level_group_ in commission_level_groups_ )
   {
      PFCommissionLevel* commission_level_ = [ PFCommissionLevel objectWithFieldOwner: commission_level_group_.fieldOwner ];
      
      if ( commission_level_.instrumentId > 0 )
      {
         [ self.instrumentCommissionLevels setObject: commission_level_ forKey: @(commission_level_.instrumentId)  ];
      }
      else
      {
         [ self.instrumentGroupCommissionLevels setObject: commission_level_ forKey: @(commission_level_.instrumentTypeId)  ];
      }
   }
}

-(BOOL)isValid
{
   if ( self.instrumentSpreadLevels.count > 0 || self.instrumentGroupSpreadLevels.count > 0 )
   {
      for ( PFSpreadLevel* level_ in self.instrumentSpreadLevels.allValues )
      {
         if ( level_.spreadMode != PFSpreadModeNotFixed || level_.bidShift != 0 || level_.askShift != 0 )
            return YES;
      }
      
      for ( PFSpreadLevel* level_ in self.instrumentGroupSpreadLevels.allValues )
      {
         if ( level_.spreadMode != PFSpreadModeNotFixed || level_.bidShift != 0 || level_.askShift != 0 )
            return YES;
      }
   }
   
   return NO;
}

-(PFSpreadLevel*)spreadLevelForInstrument: ( id< PFInstrument > )instument_
{
   PFSpreadLevel* current_spread_level_ = [ self.instrumentSpreadLevels objectForKey: @(instument_.instrumentId) ];
   
   if ( !current_spread_level_ )
   {
      if ( !( current_spread_level_ = [ self.instrumentGroupSpreadLevels objectForKey: @(instument_.group.groupId) ] ) )
      {
         current_spread_level_ =  [ self.instrumentGroupSpreadLevels objectForKey: @(instument_.group.superId) ];
      }
   }
   
   return current_spread_level_;
}

-(PFCommissionLevel*)commissionLevelForInstrument: ( id< PFInstrument > )instument_
{
   PFCommissionLevel* current_commission_level_ = [ self.instrumentCommissionLevels objectForKey: @(instument_.instrumentId) ];
   
   if ( !current_commission_level_ )
   {
      if ( !( current_commission_level_ = [ self.instrumentGroupCommissionLevels objectForKey: @(instument_.group.groupId) ] ) )
      {
         current_commission_level_ =  [ self.instrumentGroupCommissionLevels objectForKey: @(instument_.group.superId) ];
      }
   }
   
   current_commission_level_.specifiedCurrency = self.specifiedCurrency;
   
   return current_commission_level_;
}

-(NSString*)description
{
   return [ NSString stringWithFormat: @"PFSpreadPlan: planId=%d spreadLevelsCount=%d"
           , self.planId
           , (int)(self.instrumentSpreadLevels.count + self.instrumentGroupSpreadLevels.count) ];
}

@end
