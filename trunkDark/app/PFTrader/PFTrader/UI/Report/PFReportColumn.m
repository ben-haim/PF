#import "PFReportColumn.h"

#import "PFReportCell.h"

@interface PFReportColumn ()

@property ( nonatomic, strong ) NSString* columnName;

@end

@implementation PFReportColumn

@synthesize columnName;

+(id)reportColumnWithName:( NSString* )name_
{
   PFReportColumn* column_ = [ self columnWithTitle: NSLocalizedString( name_, nil )
                                          cellClass: [ PFReportCell class ] ];

   column_.columnName = name_;

   return column_;
}

-(PFGridCell*)cellForGridView:( PFGridView* )grid_view_
                      context:( id )context_
{
   PFReportCell* cell_ = (PFReportCell*)[ super cellForGridView: grid_view_ context: context_ ];

   NSDictionary* report_row_ = ( NSDictionary* )context_;
   cell_.valueLabel.text = report_row_[self.columnName];

   return cell_;
}

@end
