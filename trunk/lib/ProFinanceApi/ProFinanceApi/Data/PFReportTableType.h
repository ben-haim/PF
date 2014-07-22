#ifndef ProFinanceApi_PFReportTableType_h
#define ProFinanceApi_PFReportTableType_h

typedef enum
{
   PFReportTableTypeUndefined = -1
   , PFReportTableTypeAccountStatement
   , PFReportTableTypeBalance
   , PFReportTableTypeBalanceSummary
   , PFReportTableTypeCommissions
   , PFReportTableTypeTrades
   , PFReportTableTypeOrderHistory
   , PFReportTableTypeSummary
} PFReportTableType;

extern NSString* PFReportNameWithPFReportTableType( PFReportTableType table_type_ );
extern PFReportTableType PFReportTableTypeWithReportName( NSString* report_name_ );

#endif
