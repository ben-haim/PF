#import <UIKit/UIKit.h>

@interface PFNewsStoryCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *headerLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *categoryLabel;

+(id)storyCell;

@end
