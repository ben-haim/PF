
#import "ColorEditCell.h"
#import <QuartzCore/QuartzCore.h>
#import "PickerColorRenderer.h"
#import "PropertiesStore.h"


uint chart_nes_colors[] = {0x00000000, 0xFF0000FF,0x00FF00FF,0x0000FFFF, 0xFFFF00FF,0xFF00FFFF,
0x00FFFFFF,0x800000FF,0x008000FF,0x000080FF,0x808000FF,0x800080FF,0x008080FF,
0xC0C0C0FF,0x808080FF,0x9999FFFF,0x316396FF,0x993366FF,0xFFFFCCFF,0xCCFFFFFF,0x660066FF,
0xFF8080FF,0x0066CCFF,0xCCCCFFFF,0x000080FF,0xFF00FFFF,0xFFFF00FF,0x00FFFFFF,
0x800080FF,0x800000FF,0x008080FF,0x0000FFFF,0x00CCFFFF,0xCCFFFFFF,0xCCFFCCFF,
0xFFFF99FF,0x99CCFFFF,0xFF99CCFF,0xCC99FFFF,0xFFCC99FF,0x3366FFFF,0x33CCCCFF,
0x99CC00FF,0xFFCC00FF,0xFF9900FF,0xFF6600FF,0x666699FF,0x969696FF,
0x000000FF,0x003300FF,0xCCCCCCFF,0xEEEEEEFF,0xFFFFFFFF,0x3333FFFF, 0xFF3333FF,
0x339966FF,0x003300FF,0x333300FF,0x993300FF,0x993366FF,0x333399FF,0x333333FF,
    0x96C984FF,0x288728FF,0xD86363FF,0x881000FF};

/*{  0x7C7C7CFF, 0x0000FCFF, 0x0000BCFF, 0x4428BCFF,
    0x940084FF, 0xA80020FF, 0xA81000FF, 0x881400FF, 0x503000FF, 0x007800FF,
    0x006800FF, 0x005800FF, 0x004058FF, 0x000000FF, 0x000000FF, 0x000000FF,
    0xBCBCBCFF, 0x0078F8FF, 0x0058F8FF, 0x6844FCFF, 0xD800CCFF, 0xE40058FF,
    0xF83800FF, 0xE45C10FF, 0xAC7C00FF, 0x00B800FF, 0x00A800FF, 0x00A844FF,
    0x008888FF, 0x000000FF, 0x000000FF, 0x000000FF, 0xF8F8F8FF, 0x3CBCFCFF,
    0x6888FCFF, 0x9878F8FF, 0xF878F8FF, 0xF85898FF, 0xF87858FF, 0xFCA044FF,
    0xF8B800FF, 0xB8F818FF, 0x58D854FF, 0x58F898FF, 0x00E8D8FF, 0x787878FF,
    0x000000FF, 0x000000FF, 0xFCFCFCFF, 0xA4E4FCFF, 0xB8B8F8FF, 0xD8B8F8FF,
    0xF8B8F8FF, 0xF8A4C0FF, 0xF0D0B0FF, 0xFCE0A8FF, 0xF8D878FF, 0xD8F878FF,
    0xB8F8B8FF, 0xB8F8D8FF, 0x00FCFCFF, 0xF8D8F8FF, 0x000000FF, 0x000000FF};*/


@implementation ColorEditCell
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
    NSLog(@"properties cnt %lu", (unsigned long)[properties retainCount]);
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
    
	return sizeof(chart_nes_colors)/sizeof(int);//[pickerViewArray count];
}

#pragma mark - HorizontalPickerView Delegate Methods
/*- (NSString *)horizontalPickerView:(V8HorizontalPickerView *)picker titleForElementAtIndex:(NSInteger)index {
	return [pickerViewArray objectAtIndex:index];
}*/

- (UIView *)horizontalPickerView:(V8HorizontalPickerView *)picker viewForElementAtIndex:(NSInteger)index
{
    PickerColorRenderer *colorView = [[PickerColorRenderer alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    
    NSMutableArray *colorPalette = [[NSMutableArray alloc] init];
    
    for(int c=0; c< (uint)sizeof(chart_nes_colors)/sizeof(int); c++)
        [colorPalette addObject:[NSNumber numberWithInt:chart_nes_colors[c]]];
    [colorView setColors:colorPalette];
    [colorPalette release];
    colorView.item_index = (uint)index;
    return colorView;
}

- (NSInteger) horizontalPickerView:(V8HorizontalPickerView *)picker widthForElementAtIndex:(NSInteger)index 
{
	/*CGSize constrainedSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
	NSString *text = [pickerViewArray objectAtIndex:index];
	CGSize textSize = [text sizeWithFont:[UIFont boldSystemFontOfSize:14.0f]
					   constrainedToSize:constrainedSize
						   lineBreakMode:UILineBreakModeWordWrap];
	return textSize.width + 40.0f; // 20px padding on each side*/
    return 40;
}

- (void)horizontalPickerView:(V8HorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)index
{
	//self.infoLabel.text = [NSString stringWithFormat:@"Selected index %d", index];
    NSString* colorCodeSelected = [NSString stringWithFormat:@"%x", chart_nes_colors[index]];
    [self.properties setParam:propertyPath WithValue:colorCodeSelected];
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

-(void)SelectColor:(uint)_color
{
    int itemIndex = -1;
    for(int c=0; c< sizeof(chart_nes_colors)/sizeof(uint); c++)
    {
        if((uint)chart_nes_colors[c]==(uint)_color)
        {
            itemIndex = c;
            break;
        }
    }
    if(itemIndex==-1)
        itemIndex=0;
    [self.valueHPicker scrollToElement:itemIndex animated:false];
}

@end
