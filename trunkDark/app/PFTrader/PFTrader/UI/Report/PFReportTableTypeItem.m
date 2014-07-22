#import "PFReportTableTypeItem.h"

static NSDictionary* PFReportTitleMapping()
{
   static NSDictionary* mapping_ = nil;
   if ( !mapping_ )
   {
      mapping_ = @{ @(PFReportTableTypeAccountStatement): NSLocalizedString( @"REPORT_STATEMENT", nil )
      , @(PFReportTableTypeBalance): NSLocalizedString( @"REPORT_BALANCE", nil )
      , @(PFReportTableTypeBalanceSummary): NSLocalizedString( @"REPORT_BALANCE_SUMMARY", nil )
      , @(PFReportTableTypeCommissions): NSLocalizedString( @"REPORT_COMMISSIONS", nil )
      , @(PFReportTableTypeTrades): NSLocalizedString( @"REPORT_TRADES", nil )
      , @(PFReportTableTypeOrderHistory): NSLocalizedString( @"REPORT_ORDER_HISTORY", nil )
      , @(PFReportTableTypeSummary): NSLocalizedString( @"REPORT_SUMMARY", nil )
      };
   }

   return mapping_;
}

static NSString* PFReportTitleWithPFReportTableType( PFReportTableType table_type_ )
{
   return [ PFReportTitleMapping() objectForKey: @(table_type_) ];
}

@interface PFReportTableTypeItem ()

@property ( nonatomic, assign ) PFReportTableType tableType;
@property ( nonatomic, strong ) NSArray* availableTypes;

@end

@implementation PFReportTableTypeItem

@synthesize tableType;
@synthesize availableTypes;

-(id)initWithTableType:( PFReportTableType )table_type_
{
   self = [ super initWithAction: nil title: NSLocalizedString( @"REPORT_TYPE", nil ) ];
   if ( self )
   {
      self.tableType = table_type_;
      self.availableTypes = [ PFSession sharedSession ].supportedReportTypes;
   }

   return self;
}

-(NSString*)valueForRow:( NSInteger )row_
{
   return PFReportTitleWithPFReportTableType( (PFReportTableType)[ [ self.availableTypes objectAtIndex: row_ ] integerValue ] );
}

-(NSString*)value
{
   return PFReportTitleWithPFReportTableType( self.tableType );
}

-(NSUInteger)pickerField:( PFPickerField* )picker_field_
 numberOfRowsInComponent:( NSInteger )component_
{
   return [ self.availableTypes count ];
}

-(NSString*)pickerField:( PFPickerField* )picker_field_
            titleForRow:( NSInteger )row_
           forComponent:( NSInteger )component_
{
   return [ self valueForRow: row_ ];
}

-(NSUInteger)pickerField:( PFPickerField* )picker_field_
   currentRowInComponent:( NSInteger )component_
{
   return [ self.availableTypes indexOfObject: @(self.tableType) ];
}

-(void)pickerField:( PFPickerField* )picker_field_
      didSelectRow:( NSInteger )row_
       inComponent:( NSInteger )component_
{
   self.tableType = (PFReportTableType)[ [ self.availableTypes objectAtIndex: row_ ] integerValue ];
   picker_field_.text = PFReportTitleWithPFReportTableType( self.tableType );

   [ super pickerField: picker_field_ didSelectRow: row_ inComponent: component_ ];
}

-(BOOL)pickerField:( PFPickerField* )picker_field_
 isCyclicComponent:( NSInteger )component_
{
   return NO;
}

@end
