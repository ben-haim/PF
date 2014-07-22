#import "PFTableViewItemCell.h"

@interface PFTableViewActiveOprerationItemCell : PFTableViewItemCell

@property (nonatomic, weak) IBOutlet UILabel* symbolLabel;
@property (nonatomic, weak) IBOutlet UILabel* quantityOpenPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel* typeLabel;
@property (nonatomic, weak) IBOutlet UILabel* statusLabel;

@end
