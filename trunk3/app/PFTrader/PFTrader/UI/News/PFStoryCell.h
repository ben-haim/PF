#import "PFTableViewCell.h"

@protocol PFStory;
@protocol PFReportTable;

@interface PFStoryCell : PFTableViewCell

@property ( nonatomic, strong ) IBOutlet UILabel* headerLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* dateLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* sourceLabel;

@property ( nonatomic, strong ) id< PFStory > story;
@property ( nonatomic, strong ) id< PFReportTable > report;

@end
