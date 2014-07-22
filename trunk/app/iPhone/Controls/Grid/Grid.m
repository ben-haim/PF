
#import "Grid.h"
#include "ParamsStorage.h"
#import "ClientParams.h"

@implementation Grid
@synthesize contentView;
@synthesize cells, backImage, tableDelegate;

- (id)initWithCoder:(NSCoder*)coder 
{
    if(self=[super initWithCoder:coder])
	{
		GridColor = [UIColor clearColor];//[UIColor colorWithRed:0xCC green:0xCC blue:0xCC alpha:0xFF]; 
		[GridColor retain];
		self.scrollEnabled = YES;

		backImage = [UIImage imageNamed:@"login_bg.png"];
		//UIImageView *imgView = [[[UIImageView alloc] initWithImage:backImage] autorelease];
		//[self addSubview:imgView];
		//[parent.view addSubview:imgView];
		
		
		contentView = [[UIView alloc] initWithFrame:self.bounds];	
		cells = [[NSMutableArray alloc] init];
		cells_cache = [[NSMutableDictionary alloc] init];
		[self RecalcScroll:NO];
		[self setShowsHorizontalScrollIndicator:NO];
	}
	//[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(receivedRotate:) name: UIDeviceOrientationDidChangeNotification object: nil];
	
	
    return self;
}

- (void)dealloc 
{
    [GridColor release];
	[cells_cache release];
    [cells release];
    [super dealloc];
}

- (UIImage *)getFromCache:(NSString*)cell_id
{
	if([cells_cache objectForKey:cell_id]==nil)
		return nil;
	return (UIImage*)[cells_cache objectForKey:cell_id];
}
/*
- (NSString *)getStringFromCache:(NSString*)cell_id
{
	if([cells_cache objectForKey:cell_id]==nil)
		return nil;
	return (NSString*)[cells_cache objectForKey:cell_id];
}*/

- (void)putToCache:(NSString*)cell_id AndCell:(UIImage*)cell
{
	if([cells_cache objectForKey:cell_id]!=nil)
		[cells_cache removeObjectForKey:cell_id];
	[cells_cache setObject:cell forKey:cell_id];
}
/*
- (void)putStringToCache:(NSString*)cell_id AndCell:(NSString*)cell
{
	if([cells_cache objectForKey:cell_id]!=nil)
		[cells_cache removeObjectForKey:cell_id];
	[cells_cache setObject:cell forKey:cell_id];
}*/
-(void)ClearCells
{
	//[cells removeAllObjects];
	/*NSEnumerator *enumerator = [cells objectEnumerator];
	id value;	
	while ((value = [enumerator nextObject])) 
	{
		[value release];
	}*/
	[cells removeAllObjects];
	[self RecalcScroll:NO];
	[self setNeedsDisplay];
}
-(void)AddCell:(GridCell *)cell;
{
	cell.dataCacheDelegate = self;
	[cells addObject:cell];
	//[cell retain];
}
-(void)RecalcScroll:(BOOL)moveScroll
{
	CGPoint old_contentOffset = self.contentOffset; 
	int items_count = [cells count];
	float OveralHeight = 0;
	for(int i=0; i<items_count; i++)
	{
		GridCell *item = (GridCell *)[cells objectAtIndex:i];
		OveralHeight += item.Height;
	}

	CGRect r = self.frame;
	[self setContentSize:CGSizeMake(r.size.width, OveralHeight)];
	if(moveScroll)
		[self setContentOffset:old_contentOffset];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [[touches anyObject] retain];	
	theHitPoint = [touch locationInView:self];
	[touch release];
	//NSLog(@"touches began");
	//theHitRow
}
- (void) clearSelection:(NSSet*)touches
{	
	for(int i=0; i<[cells count] ; i++)
	{
		GridCell *item = (GridCell *)[cells objectAtIndex:i];
		item.isSelected = NO;
	}
}

- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	//NSLog(@"touches end");

	UITouch *touch = [[touches anyObject] retain];	
	CGPoint theNewHitPoint = [touch locationInView:self];
	[touch release];

	
	int deltaY = self.contentOffset.y;
	
	float OveralTop = 0;
	int first_sell_index = 0;
	
	for(int i=0; i<[cells count] ; i++)
	{
		GridCell *item = (GridCell *)[cells objectAtIndex:i];
		item.isSelected = NO;
	}
	for(int i=0; i<[cells count] ; i++)
	{
		GridCell *item = (GridCell *)[cells objectAtIndex:i];
		OveralTop += item.Height;
		if(OveralTop>=deltaY)
			break;
		first_sell_index++;
	}
	
	CGRect rect = self.bounds ;
	rect.origin.y=  -deltaY;
	int c = 0;
	
	float OveralHeight = 0;
	{
		if ([cells count]==0)
			return;
		GridCell *item = (GridCell *)[cells objectAtIndex:first_sell_index];
		CGRect cell_rect = rect;
		cell_rect.origin.y=-item.Height+ (OveralTop-deltaY);
		//cell_rect.origin.y += OveralHeight  - rect.origin.y + (OveralTop-deltaY);
		cell_rect.size.height = item.Height;
		if(CGRectContainsPoint(cell_rect, theHitPoint) && CGRectContainsPoint(cell_rect, theNewHitPoint) && item.isGroupRow!=YES)
		{
			
			NSUInteger indexes[2];
			indexes[0]=item.group_index;
			indexes[1]=item.symbol_index;
			
			NSIndexPath *p = [[NSIndexPath alloc] initWithIndexes:indexes length:2];
			//if ([tableDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
			[tableDelegate tableView:nil didSelectRowAtIndexPath:p];
			[ p release ];
			[self setNeedsDisplay];			
			[self performSelector:@selector(clearSelection:) withObject:nil afterDelay:0.5f];
			
			return;
		}
		first_sell_index++;
	}
	for(int i=first_sell_index; i<[cells count]; i++)
	{
		GridCell *item = (GridCell *)[cells objectAtIndex:i];
		CGRect cell_rect = rect;
		
		
		cell_rect.origin.y += OveralHeight  - rect.origin.y + (OveralTop);
		
		cell_rect.size.height = item.Height;
		
		if(CGRectContainsPoint(cell_rect, theHitPoint) && CGRectContainsPoint(cell_rect, theNewHitPoint) && item.isGroupRow!=YES)
		{
			((GridCell *)[cells objectAtIndex:i]).isSelected = YES;

			NSUInteger indexes[2];
			indexes[0]=item.group_index;
			indexes[1]=item.symbol_index;
			  
			NSIndexPath *p = [[NSIndexPath alloc] initWithIndexes:indexes length:2];
			//if ([tableDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
			[tableDelegate tableView:nil didSelectRowAtIndexPath:p];
         [ p release ];
			[self setNeedsDisplay];
			[self performSelector:@selector(clearSelection:) withObject:nil afterDelay:0.5f];
			return;
		}
		
		OveralHeight+=(item.Height);
		//c++;
		if(OveralHeight-c>rect.size.height+item.Height)
		{
			return;
		}
	}
}

- (void)drawRect:(CGRect)rect 
{
	//NSDate *start = [NSDate date];

	//UIGraphicsBeginImageContext(self.bounds.size);	
	CGContextRef context = UIGraphicsGetCurrentContext();
	int deltaY = self.contentOffset.y;

	[self DrawBackground:rect AndOffset:deltaY];
	
	
	CGRect clipRect = rect;
	//clipRect.origin.y=  -deltaY;	


	CGContextTranslateCTM( context, 0, deltaY);

	[self DrawCells:clipRect AndOffset:deltaY];
	
	//UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	
	//UIGraphicsEndImageContext(); 
	//context = UIGraphicsGetCurrentContext();
	//CGContextSetAllowsAntialiasing(context, NO);
	//[img drawInRect: rect];
	
	
	// do stuff...
	//NSTimeInterval timeInterval = [start timeIntervalSinceNow];
	//NSLog(@"start %f", timeInterval*1000);

}
-(void)DrawBackground:(CGRect)rect AndOffset:(int)deltaY
{	
	
	CGRect r = rect;
	//r.origin.y-=deltaY;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context,  [[ClientParams cellColor] CGColor]);
	//CGContextSetFillColorWithColor(context, [HEXCOLOR(0xE7E3DEFF) CGColor]); //CGContextSetFillColorWithColor(context, [[UIColor darkGrayColor] CGColor]);
	CGContextFillRect(context, r);
	//[backImage drawInRect: r];

}  
-(void)DrawCells:(CGRect)rect AndOffset:(int)deltaY
{
	float OveralTop = 0;
	int first_sell_index = 0; 
	if([cells count]==0)
		return;
	for(int i=0; i<[cells count] ; i++) 
	{
		GridCell *item = (GridCell *)[cells objectAtIndex:i];
		OveralTop += item.Height;
		if(OveralTop>=deltaY)
			break;
		first_sell_index++;
	}
	
	while(first_sell_index>0 && first_sell_index>=[cells count])
		first_sell_index--; 
	
	float OveralHeight = 0;

	{
		
		GridCell *item = (GridCell *)[cells objectAtIndex:first_sell_index];
		CGRect cell_rect = rect;
		cell_rect.origin.y=-item.Height+ (OveralTop-deltaY);
		//cell_rect.origin.y += OveralHeight  - rect.origin.y + (OveralTop-deltaY);
		cell_rect.size.height = item.Height;
		[item Draw:cell_rect];
		first_sell_index++;
	}
	int c = 0;
	for(int i=first_sell_index; i<[cells count]; i++)
	{
		GridCell *item = (GridCell *)[cells objectAtIndex:i];
		CGRect cell_rect = rect;
		
		cell_rect.origin.y += OveralHeight  - rect.origin.y + (OveralTop-deltaY);

		cell_rect.size.height = item.Height;
		
		[item Draw:cell_rect];
		
		OveralHeight+=(item.Height);
		//c++;
		if(OveralHeight-c>rect.size.height+item.Height)
		{
			break;
		}
	}
}
@end
