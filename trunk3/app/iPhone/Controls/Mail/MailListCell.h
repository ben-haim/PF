#import <UIKit/UIKit.h>


@interface MailListCell : UITableViewCell 
{
	IBOutlet UIImageView *imgIcon;
	IBOutlet UILabel *lblFrom;
	IBOutlet UILabel *lblDate;
	IBOutlet UILabel *lblSubject;
}


@property (nonatomic, retain) IBOutlet UIImageView *imgIcon;
@property (nonatomic, retain) IBOutlet UILabel *lblFrom;
@property (nonatomic, retain) IBOutlet UILabel *lblDate;
@property (nonatomic, retain) IBOutlet UILabel *lblSubject;
@end
