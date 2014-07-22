#import "PFReportTable.h"

@interface PFReportTable ()

@property ( nonatomic, strong ) NSArray* header;
@property ( nonatomic, strong ) NSMutableArray* mutableRows;

@end

@implementation PFReportTable

@synthesize name;
@synthesize date;
@synthesize dialog;
@synthesize header;
@synthesize mutableRows = _mutableRows;

@dynamic rows;

-(NSArray*)rows
{
   return self.mutableRows;
}

-(NSMutableArray*)mutableRows
{
   if ( !_mutableRows )
   {
      _mutableRows = [ NSMutableArray new ];
   }
   return _mutableRows;
}

-(void)addRow:( NSArray* )values_
{
   //First row is header
   if ( !self.header )
   {
      self.header = values_;
   }
   else
   {
      NSAssert( [ values_ count ] == [ self.header count ], @"Invalid table" );

      NSMutableDictionary* row_ = [ NSMutableDictionary dictionaryWithCapacity: [ values_ count ] ];

      for ( NSUInteger i_ = 0; i_ < [ self.header count ]; ++i_ )
      {
         NSString* key_ = [ self.header objectAtIndex: i_ ];
         NSString* value_ = [ values_ objectAtIndex: i_ ];

         [ row_ setObject: value_ forKey: key_ ];
      }

      [ self.mutableRows addObject: row_ ];
   }
}

-(NSString*)description
{
   return [ self.mutableRows description ];
}

+(id)reportWithString:( NSString* )message_
{
   PFReportTable* report_ = [ PFReportTable new ];
   
   report_.name = message_;
   report_.date = [ NSDate date ];
   report_.dialog = @"";
   report_.header = [ NSArray arrayWithObjects: @"Title", @"Value", nil ];
   [ report_.mutableRows addObject: [ NSDictionary dictionaryWithObjectsAndKeys: @"Event:", @"Title", message_, @"Value", nil ] ];
   
   return report_;
}

@end
