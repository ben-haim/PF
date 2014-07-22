#import "PFReportTable.h"

@interface PFReportTable ()

@property ( nonatomic, strong ) NSArray* header;
@property ( nonatomic, strong ) NSMutableArray* mutableRows;
@property ( nonatomic, assign ) BOOL isTransformed;

@end

@implementation PFReportTable

@synthesize name;
@synthesize date;
@synthesize dialog;
@synthesize header;
@synthesize mutableRows = _mutableRows;
@synthesize isTransformed;

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

-(PFReportTable*)transformedTable
{
    if ( self.rows.count == 1 && self.header.count > 1 && [ [ self.rows objectAtIndex: 0 ] count ] > 0 )
    {
        PFReportTable* transformed_table_ = [ PFReportTable new ];
        
        transformed_table_.isTransformed = YES;
        transformed_table_.name = self.name;
        transformed_table_.dialog = self.dialog;
        transformed_table_.date = self.date;
        transformed_table_.header = [ NSArray arrayWithObjects: [ self.header objectAtIndex: 0 ], [ [ self.rows objectAtIndex: 0 ] objectForKey: [ self.header objectAtIndex: 0 ] ] , nil ];
        
        for ( int index_ = 1; index_ < self.header.count; index_++ )
        {
            [ transformed_table_ addRow: [ NSArray arrayWithObjects: [ self.header objectAtIndex: index_ ], [ [ self.rows objectAtIndex: 0 ] objectForKey: [ self.header objectAtIndex: index_ ] ], nil ] ];
        }
        
        return transformed_table_;
    }
    else
    {
        return nil;
    }
}

@end
