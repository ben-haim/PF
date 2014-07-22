
#import "HeaderGridCell.h"


@implementation HeaderGridCell


-(HeaderGridCell *)initWithText:(NSString*)_text isFirst:(BOOL)first
{
	isFirst = first;
	isGroupRow = NO;
	isSelected = NO;
	
	Height = (isFirst)?33:26;

	self.text = _text;
	/*HeaderGroupCell *cell = nil;
	NSArray *topLevelObjects = [[NSBundle mainBundle]
								loadNibNamed:@"HeaderGridCell" 
								owner:nil 
								options:nil];
	
	for(id currentObject in topLevelObjects)
	{
		if([currentObject isKindOfClass:[UITableViewCell class]])
		{
			cell = (HeaderGroupCell *)currentObject;
			
			break;
		}
	}
	cell.frame = CGRectMake(0, 0, 320, 50);
	groupCell = [cell retain];
	//groupCell.lblTitle.text = self.text;*/
	
	/*UIImage *rowBG = (UIImage*)[dataCacheDelegate getFromCache:@"headerImg"];
	if(rowBG==nil)
	{
		rowBG = [UIImage imageNamed:@"HeaderCell.png"];
		[dataCacheDelegate putToCache:@"headerImg" AndCell:rowBG];
	}	
	CGRect bgRect = CGRectMake(0, 0, 320, 50);
	bgRect.origin.x = 0;
	bgRect.origin.y = 0;
	bgRect.size.width = rowBG.size.width;
	bgRect.size.height = rowBG.size.height;
	[rowBG drawInRect: bgRect];*/
	
	
	
	return self;
}

-(HeaderGridCell *)initWithText:(NSString*)_text
{
	isGroupRow = NO;
	isSelected = NO;
	
	Height = 26;
	
	self.text = _text;

	return self;
}

-(void)Draw:(CGRect)rect
{
	/*CGContextTranslateCTM( UIGraphicsGetCurrentContext(), 0, rect.origin.y);
	[[groupCell layer]  renderInContext:UIGraphicsGetCurrentContext()];
	
	CGContextTranslateCTM( UIGraphicsGetCurrentContext(), 0, -rect.origin.y);*/
	//[upCell setNeedsDisplayInRect:rect ];
	//[upCell drawRect:rect];
	int bgDelta = (isFirst)?7:0;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetStrokeColorWithColor(context, [[UIColor clearColor] CGColor]);     
	CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]); 
	
	
	UIImage *rowBG = (UIImage*)[dataCacheDelegate getFromCache:@"headerImg"];
	if(rowBG==nil)
	{
		rowBG = [UIImage imageNamed:@"row_header_clear.png"];
		[dataCacheDelegate putToCache:@"headerImg" AndCell:rowBG];
	}	
	CGRect bgRect = rect;
	bgRect.origin.x = 0;
	bgRect.origin.y = rect.origin.y+bgDelta;// + (rect.size.height-rowArrow.size.height)/2;
	bgRect.size.width = rowBG.size.width;
	bgRect.size.height = rowBG.size.height;
	[rowBG drawInRect: bgRect];
	
	UIImage *img1 = (UIImage*)[dataCacheDelegate getFromCache:@"headerImg2"];
	if(img1==nil)
	{
		img1 = [UIImage imageNamed:@"row_header_title.png"];
		[dataCacheDelegate putToCache:@"headerImg2" AndCell:img1];
	}
	UIImage *stretchImage = (UIImage*)[dataCacheDelegate getFromCache:@"headerImg3"];
	if(stretchImage==nil)
	{
		stretchImage = [img1 stretchableImageWithLeftCapWidth:17 topCapHeight:1];
		[dataCacheDelegate putToCache:@"headerImg3" AndCell:stretchImage];
	}
	
	UIFont *font = (UIFont*)[dataCacheDelegate getFromCache:@"HelveticaBold_15"];
	if(font==nil)
	{
		font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
		[dataCacheDelegate putToCache:@"HelveticaBold_15" AndCell:(UIImage*)font];
	}
	
	//UIImage *img1 = [UIImage imageNamed:@"row_header_title.png"];
	//UIImage *stretchImage1 = [img1 stretchableImageWithLeftCapWidth:15 topCapHeight:1];
	
	CGSize textSize = [self.text sizeWithFont:font];	
	
	CGRect bgRect1 = rect;
	bgRect1.origin.x = 5;
	bgRect1.origin.y = rect.origin.y+bgDelta;
	bgRect1.size.width = textSize.width+25;
	bgRect1.size.height = stretchImage.size.height;
	[stretchImage drawInRect: bgRect1];
	
	
	
	[self.text drawInRect:CGRectMake(19, rect.origin.y+3+bgDelta, 287, 22) withFont:font];

	
}



@end
