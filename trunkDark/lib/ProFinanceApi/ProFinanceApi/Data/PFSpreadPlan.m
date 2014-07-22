#import "PFSpreadPlan.h"

#import "PFMessage.h"
#import "PFField.h"
#import "PFMetaObject.h"

#import "PFSpreadLevel.h"

#import "PFInstrument.h"
#import "PFInstrumentGroup.h"

@interface PFSpreadPlan ()

@property ( nonatomic, strong ) NSMutableDictionary* instrumentSpreadLevels;
@property ( nonatomic, strong ) NSMutableDictionary* instrumentGroupSpreadLevels;

@end

@implementation PFSpreadPlan

@synthesize name;
@synthesize description;
@synthesize counterAccountId;
@synthesize planId;

@synthesize instrumentSpreadLevels;
@synthesize instrumentGroupSpreadLevels;

+(PFMetaObject*)metaObject
{
   return [ PFMetaObject metaObjectWithFields:
           @[[ PFMetaObjectField fieldWithId: PFFieldCommissionPlanId name: @"planId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldName name: @"name" ]
            , [ PFMetaObjectField fieldWithId: PFFieldDescription name: @"description" ]
            , [ PFMetaObjectField fieldWithId: PFFieldCounterAccountId name: @"counterAccountId" ]] ];
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
         (self.instrumentSpreadLevels)[@(spread_level_.instrumentId)] = spread_level_;
      }
      else
      {
         (self.instrumentGroupSpreadLevels)[@(spread_level_.instrumentTypeId)] = spread_level_;
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
   PFSpreadLevel* current_spread_level_ = (self.instrumentSpreadLevels)[@(instument_.instrumentId)];
   
   if ( !current_spread_level_ )
   {
      if ( !( current_spread_level_ = (self.instrumentGroupSpreadLevels)[@(instument_.group.groupId)] ) )
      {
         current_spread_level_ =  (self.instrumentGroupSpreadLevels)[@(instument_.group.superId)];
      }
   }
   
   return current_spread_level_;
}

-(NSString*)description
{
   return [ NSString stringWithFormat: @"PFCommissionPlan: planId=%d spreadLevelsCount=%lu"
           , self.planId
           , (unsigned long)(self.instrumentSpreadLevels.count + self.instrumentGroupSpreadLevels.count) ];
}

@end
