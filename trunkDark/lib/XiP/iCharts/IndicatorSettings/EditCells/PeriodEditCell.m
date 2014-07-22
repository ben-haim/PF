
#import "PeriodEditCell.h"
#import <QuartzCore/QuartzCore.h>
#import "PropertiesStore.h"



@implementation PeriodEditCell
@synthesize lblTitle, pickerViewArray, valueHPicker, propertyPath, properties;
@synthesize min, max, step, digits;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) 
    {
        
        CGFloat width = 160;
        CGFloat x = 152;
        CGRect tmpFrame = CGRectMake(x, 5, width, 35);
        
        pickerViewArray = [[NSMutableArray alloc] initWithObjects:@"Close", @"Open", @"High", @"Low", @"HL/2", @"HLC/3", @"HLCC/4", nil];
        
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
	return [pickerViewArray count];
}

#pragma mark - HorizontalPickerView Delegate Methods
- (NSString *)horizontalPickerView:(V8HorizontalPickerView *)picker titleForElementAtIndex:(NSInteger)index 
{
	return pickerViewArray[index];
}


- (NSInteger) horizontalPickerView:(V8HorizontalPickerView *)picker widthForElementAtIndex:(NSInteger)index 
{
	CGSize constrainedSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
	NSString *text = pickerViewArray[index];
	CGSize textSize = [text sizeWithFont:[UIFont boldSystemFontOfSize:14.0f]
					   constrainedToSize:constrainedSize
						   lineBreakMode:UILineBreakModeWordWrap];
	return textSize.width + 40.0f; // 20px padding on each side
}

- (void)horizontalPickerView:(V8HorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)index
{
    NSString* valueSelected = nil;
    if(digits==0)
        valueSelected = [NSString stringWithFormat:@"%d", (int)index + (int)min];
    else
        valueSelected = [NSString stringWithFormat:@"%f", index*step + min];
    [self.properties setParam:propertyPath WithValue:valueSelected];
   // NSLog(@"propertyPath %@", propertyPath);
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

-(void)SetMin:(uint)_min AndMax:(uint)_max
{
    [self SetInternalMin:_min AndMax:_max AndStep:1 AndDigits:0];
}
-(void)SetInternalMin:(double)_min 
               AndMax:(double)_max 
              AndStep:(double)_step 
            AndDigits:(uint)_digits
{
    min = _min;
    max = _max;
    step = _step;
    digits = _digits;
    
    pickerViewArray = [[NSMutableArray alloc] initWithCapacity:max - min];
    
    double v = min;
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[nf setDecimalSeparator:@"."];
	[nf setGeneratesDecimalNumbers:TRUE];
	[nf setMinimumFractionDigits:digits];
	[nf setMinimumIntegerDigits:1];
	[nf setMaximumFractionDigits:digits];
    [nf setRoundingMode:NSNumberFormatterRoundHalfUp];
    while (v<=max) 
    {
        [pickerViewArray addObject:[nf stringFromNumber:@(v)]];
        v+=step;
    }
    [valueHPicker reloadData];
    
}


-(void)SelectValue:(double)_value
{
    int index = roundf((_value-min)/step);
    [self.valueHPicker scrollToElement:index animated:false];
}

@end
