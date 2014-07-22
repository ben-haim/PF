
#import "GridCell.h"
#include "ParamsStorage.h"
#import "ClientParams.h"

@implementation GridCell
@synthesize isGroupRow, isSelected, Height,text, dataCacheDelegate, firstInGroup, lastInGroup, group_index, symbol_index, SelectedColor;

-(GridCell *)init
{
	isGroupRow = NO;
	isSelected = NO;
	isBalanceRow = NO;
	Height = 60;
	text = nil;
	return self;
}
-(void)Draw:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();	
	
	CGRect r = rect;
	
	UIColor *color_selected;
	
	if (isBalanceRow)
	{
		color_selected = (UIColor*)[dataCacheDelegate getFromCache:@"color_selected_balance"];
		if(color_selected==nil)
		{
			color_selected = [ClientParams cellColorSelected];
			[dataCacheDelegate putToCache:@"color_selected_balance" AndCell:(UIImage*)color_selected];
		}
	}
	else
	{
		color_selected = (UIColor*)[dataCacheDelegate getFromCache:@"color_selected"];
		if(color_selected==nil)
		{
			color_selected = [ClientParams cellColorSelected];
			[dataCacheDelegate putToCache:@"color_selected" AndCell:(UIImage*)color_selected];
		}
	}
	UIColor *bg_color = (UIColor*)[dataCacheDelegate getFromCache:@"bg_color"];
	if(bg_color==nil)
	{
		bg_color = [ClientParams cellColor];;
		[dataCacheDelegate putToCache:@"bg_color" AndCell:(UIImage*)bg_color];
	}
	
	UIColor *backColor;
	backColor=  isSelected?color_selected:bg_color;
	CGContextSetFillColorWithColor(context, [backColor CGColor]);
	CGContextFillRect(context, r);
//	[backColor autorelease];
}
-(void)DrawInRect:(NSString *)str context:(CGContextRef)context drawInRect:(CGRect)drawInRect
		lineBreakMode:(UILineBreakMode)lineBreakMode alignment:(UITextAlignment)alignment
		name:(const char *)name size:(CGFloat)size
{
	CGContextSelectFont(context, name, size, kCGEncodingMacRoman); 
	int deltaX = 0;
	if(alignment == UITextAlignmentRight)
	{
		CGContextSetTextDrawingMode(context, kCGTextInvisible); 
		CGContextSetTextPosition(context, drawInRect.origin.x, drawInRect.origin.y + size);	
		CGContextShowText(context, [str UTF8String], strlen([str UTF8String]));
		CGPoint pt = CGContextGetTextPosition(context);
		
		int textPixelLength = pt.x - drawInRect.origin.x;
		deltaX = drawInRect.size.width - textPixelLength;		
	}
	
	CGContextSetTextDrawingMode(context, kCGTextFill); 
	CGContextSetTextPosition(context, drawInRect.origin.x+deltaX, drawInRect.origin.y + size);	
	CGContextShowText(context, [str UTF8String], strlen([str UTF8String]));
	
}
@end
