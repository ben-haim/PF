
#import "LineDashEditCell.h"
#import <QuartzCore/QuartzCore.h>
#import "LineDashRenderer.h"
#import "PropertiesStore.h"



@implementation LineDashEditCell
@synthesize lblTitle, valueHPicker, propertyPath, properties;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        
    }
    return self;
}

- (void)dealloc
{
    [lblTitle release];
    [valueHPicker release];
    if(properties)
        [properties release];
    if(propertyPath)
        [propertyPath release];
    [super dealloc];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) 
    {
        
        CGFloat width = 160;
        CGFloat x = 152;
        CGRect tmpFrame = CGRectMake(x, 5, width, 35);
        valueHPicker = [[V8HorizontalPickerView alloc] initWithFrame:tmpFrame];
        valueHPicker.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        
        self.valueHPicker.backgroundColor   = [UIColor clearColor];
        self.valueHPicker.selectedTextColor = [UIColor grayColor];
        self.valueHPicker.textColor   = [UIColor grayColor];
        self.valueHPicker.delegate    = self;
        self.valueHPicker.dataSource  = self;
        self.valueHPicker.elementFont = [UIFont boldSystemFontOfSize:14.0f];
        self.valueHPicker.selectionPoint = CGPointMake(tmpFrame.size.width/2, 0);
        [self.valueHPicker scrollToElement:0 animated:false];
        valueHPicker.layer.borderWidth        = 0;

  
        
        CALayer *innerShadowLayer = [CALayer layer];
        innerShadowLayer.contents = (id)[UIImage imageNamed: @"picker_frame.png"].CGImage;        innerShadowLayer.frame = CGRectMake(0, 0, tmpFrame.size.width, tmpFrame.size.height);
        [valueHPicker.layer insertSublayer:innerShadowLayer atIndex:1 ];
        [self addSubview:valueHPicker];
    }
    return self;
}

#pragma mark - HorizontalPickerView DataSource Methods
- (NSInteger)numberOfElementsInHorizontalPickerView:(V8HorizontalPickerView *)picker 
{
    
	return 5;
}

#pragma mark - HorizontalPickerView Delegate Methods
/*- (NSString *)horizontalPickerView:(V8HorizontalPickerView *)picker titleForElementAtIndex:(NSInteger)index {
	return [pickerViewArray objectAtIndex:index];
}*/

- (UIView *)horizontalPickerView:(V8HorizontalPickerView *)picker viewForElementAtIndex:(NSInteger)index
{
    LineDashRenderer *lwView = [[LineDashRenderer alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    lwView.item_index = (int)index;
    return [lwView autorelease];
}

- (NSInteger) horizontalPickerView:(V8HorizontalPickerView *)picker widthForElementAtIndex:(NSInteger)index 
{
	/*CGSize constrainedSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
	NSString *text = [pickerViewArray objectAtIndex:index];
	CGSize textSize = [text sizeWithFont:[UIFont boldSystemFontOfSize:14.0f]
					   constrainedToSize:constrainedSize
						   lineBreakMode:UILineBreakModeWordWrap];
	return textSize.width + 40.0f; // 20px padding on each side*/
    return 80;
}

- (void)horizontalPickerView:(V8HorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)index
{
	//self.infoLabel.text = [NSString stringWithFormat:@"Selected index %d", index];
    NSString* dashSelected = [NSString stringWithFormat:@"%d", (int)index];
    [self.properties setParam:propertyPath WithValue:dashSelected];
}


- (void)layoutSubviews 
{   
    [super layoutSubviews];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)SelectDash:(uint)_dash
{
    //width is 1,2,3,4 in pixels, and this corresponds to element indices
    //CHART_DASH_1 - CHART_DASH_4
    [self.valueHPicker scrollToElement:(_dash) animated:false];
}

@end
