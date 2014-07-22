#import "PFTableViewItemCell.h"

@interface PFTableViewPositionItemCell : PFTableViewItemCell

@property (nonatomic, weak) IBOutlet UILabel* symbolLabel;
@property (nonatomic, weak) IBOutlet UILabel* netPLLabel;
@property (nonatomic, weak) IBOutlet UILabel* quantityOpenPriceLabel;
@property (nonatomic, weak) IBOutlet UIImageView* arrowImage;
@property (nonatomic, weak) IBOutlet UIImageView* thinArrowImage;

@end
