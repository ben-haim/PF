
#import "YesNoCell.h"
#import <QuartzCore/QuartzCore.h>
#import "PropertiesStore.h"



@implementation YesNoCell
@synthesize lblTitle, propertyPath, properties;

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
        //[swYesNo addTarget:self action:@selector(switchChanged) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}
/*- (void) switchChanged:(id)sender 
{
}*/

- (IBAction)valueChanged:(id)sender 
{
    NSString* valueSelected = [NSString stringWithFormat:@"%d", [swYesNo isOn]?1:0];
    [self.properties setParam:propertyPath WithValue:valueSelected];
}


-(void)SelectBool:(uint)_bool_value
{
    [swYesNo setOn:(_bool_value>0) animated:NO];
}

@end
