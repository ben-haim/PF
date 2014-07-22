#import "PFChatHolderView.h"

@interface PFChatHolderView ()

@property ( nonatomic, assign ) CGFloat tableWidth;

@end

@implementation PFChatHolderView

@synthesize tableView;
@synthesize tableWidth;

-(void)layoutSubviews
{
   if ( self.tableWidth != self.bounds.size.width )
   {
      [ self.tableView reloadData ];
      self.tableWidth = self.bounds.size.width;
   }
}

@end
