
#import <UIKit/UIKit.h>

#import "GridCell.h"
#import "HeaderGroupCell.h"

@interface HeaderGridCell : GridCell 
{
	HeaderGroupCell *groupCell;
	BOOL isFirst;
}
-(HeaderGridCell *)initWithText:(NSString*)_text isFirst:(BOOL)first;
-(HeaderGridCell *)initWithText:(NSString*)_text;
-(void)Draw:(CGRect)rect;
@end
