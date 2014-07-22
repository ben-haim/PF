#import "PFNewsStoryCell.h"

@implementation PFNewsStoryCell

@synthesize headerLabel = _headerLabel;
@synthesize dateLabel = _dateLabel;
@synthesize categoryLabel = _categoryLabel;

-(void)dealloc
{
   [ _headerLabel release ];
   [ _dateLabel release ];
   [ _categoryLabel release ];
   
   [ super dealloc ];
}

+(id)storyCell
{
   UIViewController* controller_ = [ [ [ UIViewController alloc ] initWithNibName: @"PFNewsStoryCell" bundle: nil ] autorelease ];

   return controller_.view;
}

@end
