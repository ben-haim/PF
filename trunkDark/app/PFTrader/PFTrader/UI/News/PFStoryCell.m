#import "PFStoryCell.h"
#import "UIColor+Skin.h"
#import "NSDateFormatter+PFTrader.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFStoryCell

@synthesize headerLabel;
@synthesize dateLabel;
@synthesize sourceLabel;

@synthesize story = _story;
@synthesize report = _report;

-(void)awakeFromNib
{
   [ super awakeFromNib ];
   
   self.headerLabel.textColor = [ UIColor blueTextColor ];
   self.dateLabel.textColor = [ UIColor blueTextColor ];
   self.sourceLabel.textColor = [ UIColor blueTextColor ];
}

-(void)setStory:( id< PFStory > )story_
{
   self.headerLabel.text = story_.header;
   self.dateLabel.text = [ [ NSDateFormatter newsDateFormatter ] stringFromDate: story_.date ];
   self.sourceLabel.text = story_.source;

   _story = story_;
}

-(void)setReport:( id<PFReportTable> )report_
{
   self.headerLabel.text = report_.name;
   self.dateLabel.text = [ [ NSDateFormatter newsDateFormatter ] stringFromDate: report_.date ];
   self.sourceLabel.text = report_.dialog;
   
   _report = report_;
}

@end
