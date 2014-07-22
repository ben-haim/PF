#import "PFReportTableType.h"

static NSString* const PFReportNameAccountStatement = @"Account Statement Report";
static NSString* const PFReportNameBalance = @"Balance Report";
static NSString* const PFReportNameBalanceSummary = @"Balance Summary Report";
static NSString* const PFReportNameCommissions = @"Commisions Report";
static NSString* const PFReportNameTrades = @"Trades Report";
static NSString* const PFReportNameOrderHistory = @"Order History Report";
static NSString* const PFReportNameSummaryReport = @"Summary Report";

static NSDictionary* PFReportTableTypeNameMapping()
{
   static NSDictionary* mapping_ = nil;
   if ( !mapping_ )
   {
      mapping_ = @{ @(PFReportTableTypeAccountStatement): PFReportNameAccountStatement
      , @(PFReportTableTypeBalance): PFReportNameBalance
      , @(PFReportTableTypeBalanceSummary): PFReportNameBalanceSummary
      , @(PFReportTableTypeCommissions): PFReportNameCommissions
      , @(PFReportTableTypeTrades): PFReportNameTrades
      , @(PFReportTableTypeOrderHistory): PFReportNameOrderHistory
      , @(PFReportTableTypeSummary): PFReportNameSummaryReport
      };
   }
   return mapping_;
}

extern NSString* PFReportNameWithPFReportTableType( PFReportTableType table_type_ )
{
   NSString* name_ = [ PFReportTableTypeNameMapping() objectForKey: @(table_type_) ];
   assert( name_ != nil && "undefined table type" );
   return name_;
}

PFReportTableType PFReportTableTypeWithReportName( NSString* report_name_ )
{
   NSDictionary* mapping_ = PFReportTableTypeNameMapping();
   for ( NSNumber* type_ in mapping_ )
   {
      NSString* current_name_ = [ mapping_ objectForKey: type_ ];
      if ( [ current_name_ isEqualToString: report_name_ ] )
      {
         return (int)[ type_ integerValue ];
      }
   }
   return PFReportTableTypeUndefined;
}
