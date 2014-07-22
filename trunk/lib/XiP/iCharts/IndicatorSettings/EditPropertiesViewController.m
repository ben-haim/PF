
#import "EditPropertiesViewController.h"
#import "CMColourBlockView.h"
#import "ColorEditCell.h"
#import "LineWidthEditCell.h"
#import "LineDashEditCell.h"
#import "ApplyToEditCell.h"
#import "PeriodEditCell.h"
#import "YesNoCell.h"
#import "PropertiesStore.h"
#import "Utils.h"

@implementation PropertySection : NSObject 
@synthesize name, props;

- (id) initWithName:(NSString*)section_name andProps:(NSArray*)_props
{
    self = [super init];
    if(!self)
        return self;
    [self setName:section_name];
    [self setProps:_props];
    return self;
}

- (void)dealloc
{
    [name release];
    [props release];
    [super dealloc];
}
@end


@implementation EditPropertiesViewController
@synthesize tableLayout, properties, lblTitle, btnDone;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        tableLayout = [[NSMutableArray alloc] init];
        properties = nil;
    }
    return self;
}

- (void)dealloc
{
    [settingsTableView release];
    [tableLayout release];
    [lblTitle release];

    settingsTableView = nil;
    if(properties)
        [properties release];
    lblTitle = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    settingsTableView.rowHeight = 45;    
    [lblTitle setTitle:title];
    [btnDone setTitle:NSLocalizedString(@"BUTTONS_DONE", @"Done")];
    /*self.tableLayout = [NSArray arrayWithObjects:
                                [NSArray arrayWithObjects:
                                 self.defaultSettingsCell,
                                 nil],
                                [NSArray arrayWithObjects:
                                 self.sizeCell,
                                 self.fontCell,
                                 self.colourCell,
                                 nil],
                                [NSArray arrayWithObjects:
                                 self.applyAsDefaultCell,
                                 nil],
                                nil];*/
    // Do any additional setup after loading the view from its nib.
    if (self.navigationController) 
    {
        [self.navigationController setNavigationBarHidden:YES];
    }
}


-(void)ShowProperties:(PropertiesStore*)store 
            WithTitle:(NSString*)__title      
              ForPath:(NSString*)path 
           WithNotify:(NSString*)_notify_msg
{      
    if(properties)
        [properties release];
    [self setProperties:store];
    notify_msg = _notify_msg; 
    title = __title;
    NSArray *sec_order = [store getArray:[NSString stringWithFormat:@"%@.sec_order",path]];
    for (NSString *sec_name in sec_order)
    {        
        NSArray *order = [store getArray:[NSString stringWithFormat:@"%@.%@.order", path, sec_name]];
        NSMutableArray *props_list = [[NSMutableArray alloc] initWithCapacity:[order count]];
        
        for (NSString *property_name in order) 
        {            
            [props_list addObject:[NSString stringWithFormat:@"%@.%@.%@", 
                                   path, 
                                   sec_name, 
                                   property_name]];            
        }
        NSString* sect_title = [store getParam:[NSString stringWithFormat:@"%@.%@.name", path, sec_name]];
        NSString* sect_title_loc = NSLocalizedString(sect_title, @"section label");
        PropertySection *sect = [[PropertySection alloc] initWithName:sect_title_loc
                                                             andProps:props_list];
        [tableLayout addObject:sect]; 
        [props_list release];
        [sect release];        
    }
    //NSLog(@"sec order %@", tableLayout);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}
- (IBAction)btnDonePressed:(id)sender 
{
    [self dismissModalViewControllerAnimated:YES];    
    [[NSNotificationCenter defaultCenter] postNotificationName:notify_msg object:properties];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    // Return the number of sections.
    return [tableLayout count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    PropertySection *sect = [tableLayout objectAtIndex:section];
    return [sect.props count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    PropertySection *sect = [tableLayout objectAtIndex:section];
    return sect.name;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    PropertySection *sect = [tableLayout objectAtIndex:indexPath.section];    
    NSString* propertyPath = [sect.props objectAtIndex:indexPath.row];
    NSDictionary * property = [properties getDict:propertyPath];
    int dataType = [[property objectForKey:@"type"] intValue];
    //NSLog(@"dataType %d", dataType);
    if(dataType==PROPERTY_TYPE_COLOR)
    {
        NSString *CellIdentifier = @"ChartPropertiesColorCell";
        ColorEditCell *cell = (ColorEditCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) 
        {
            cell = (ColorEditCell*)[[[NSBundle mainBundle] loadNibNamed:@"ColorEditCell" 
                                           owner:self 
                                         options:nil] objectAtIndex:0];
        }    
        
        cell.lblTitle.text = NSLocalizedString([property objectForKey:@"label"], @"field label");
        //read the color value
        NSString *colorString = [property objectForKey:@"value"];
        uint outVal;
        NSScanner* scanner = [NSScanner scannerWithString:colorString];
        [scanner scanHexInt:&outVal];
        //set the color value
        [cell SelectColor:outVal];
        [cell setPropertyPath:propertyPath];
        [cell setProperties:properties];
        return cell;
    }
    else
    if(dataType==PROPERTY_TYPE_LINE_WIDTH)
    {
        NSString *CellIdentifier = @"ChartPropertiesLineWidthCell";
        LineWidthEditCell *cell = (LineWidthEditCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) 
        {
            cell = (LineWidthEditCell*)[[[NSBundle mainBundle] loadNibNamed:@"LineWidthEditCell" 
                                                                  owner:self 
                                                                options:nil] objectAtIndex:0];
        }    
        
        cell.lblTitle.text = NSLocalizedString([property objectForKey:@"label"], @"field label");
        //read the width value
        int lineWidth = [[property objectForKey:@"value"] intValue];
        
        [cell SelectWidth:lineWidth];
        [cell setPropertyPath:propertyPath];
        [cell setProperties:properties];
        return cell;
    }
    else
    if(dataType==PROPERTY_TYPE_LINE_DASH)
    {
        NSString *CellIdentifier = @"ChartPropertiesLineDashCell";
        LineDashEditCell *cell = (LineDashEditCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) 
        {
            cell = (LineDashEditCell*)[[[NSBundle mainBundle] loadNibNamed:@"LineDashEditCell" 
                                                                      owner:self 
                                                                    options:nil] objectAtIndex:0];
        }    
        
        cell.lblTitle.text = NSLocalizedString([property objectForKey:@"label"], @"field label");
        //read the width value
        int lineDash = [[property objectForKey:@"value"] intValue];
        [cell SelectDash:lineDash];
        [cell setPropertyPath:propertyPath];
        [cell setProperties:properties];
        return cell;
    }
    else
    if(dataType==PROPERTY_TYPE_APPLY_TO)
    {
        NSString *CellIdentifier = @"ChartPropertiesApplyToCell";
        ApplyToEditCell *cell = (ApplyToEditCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) 
        {
            cell = (ApplyToEditCell*)[[[NSBundle mainBundle] loadNibNamed:@"ApplyToEditCell" 
                                                                     owner:self 
                                                                   options:nil] objectAtIndex:0];
        }    
        
        cell.lblTitle.text = NSLocalizedString([property objectForKey:@"label"], @"field label");
        //read the width value
        int applyTo = [[property objectForKey:@"value"] intValue];
        [cell SelectApplyTo:applyTo];
        [cell setPropertyPath:propertyPath];
        [cell setProperties:properties];
        return cell;
    }  
    else
    if(dataType==PROPERTY_TYPE_BOOL)
    {
        NSString *CellIdentifier = @"ChartPropertiesYesNoCell";
        YesNoCell *cell = (YesNoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) 
        {
            cell = (YesNoCell*)[[[NSBundle mainBundle] loadNibNamed:@"YesNoCell" 
                                                                   owner:self 
                                                                 options:nil] objectAtIndex:0];
        }    
        
        cell.lblTitle.text = NSLocalizedString([property objectForKey:@"label"], @"field label");
        //read the width value
        int value = [[property objectForKey:@"value"] intValue];
        [cell SelectBool:value];
        [cell setPropertyPath:propertyPath];
        [cell setProperties:properties];
        return cell;
        
    }
    else
    if(dataType==PROPERTY_TYPE_UINT)
    {
        NSString *CellIdentifier = @"ChartPropertiesPeriodCell";
        PeriodEditCell *cell = (PeriodEditCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) 
        {
            cell = (PeriodEditCell*)[[[NSBundle mainBundle] loadNibNamed:@"PeriodEditCell" 
                                                                    owner:self 
                                                                  options:nil] objectAtIndex:0];
        }    
        
        cell.lblTitle.text = NSLocalizedString([property objectForKey:@"label"], @"field label");
        //read the width value
        int value = [[property objectForKey:@"value"] intValue];
        int min = [[property objectForKey:@"min"] intValue];
        int max = [[property objectForKey:@"max"] intValue];
        [cell SetMin:min AndMax:max];
        [cell SelectValue:value];
        [cell setPropertyPath:propertyPath];
        [cell setProperties:properties];
        return cell;
    }
    else
    if(dataType==PROPERTY_TYPE_DBL)
    {
        NSString *CellIdentifier = @"ChartPropertiesPeriodCell";
        PeriodEditCell *cell = (PeriodEditCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) 
        {
            cell = (PeriodEditCell*)[[[NSBundle mainBundle] loadNibNamed:@"PeriodEditCell" 
                                                                   owner:self 
                                                                 options:nil] objectAtIndex:0];
        }    
        
        cell.lblTitle.text = NSLocalizedString([property objectForKey:@"label"], @"field label");
        //read the width value
        double value = [[property objectForKey:@"value"] doubleValue];
        double min = [[property objectForKey:@"min"] doubleValue];
        double max = [[property objectForKey:@"max"] doubleValue];
        double step = [[property objectForKey:@"step"] doubleValue];
        int digits = [[property objectForKey:@"digits"] intValue];
        [cell SetInternalMin:min AndMax:max AndStep:step AndDigits:digits];
        [cell SelectValue:value];
        [cell setPropertyPath:propertyPath];
        [cell setProperties:properties];
        return cell;
    }    
    else
        return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    //IASKSpecifier *specifier  = [self.settingsReader specifierForIndexPath:indexPath];
    //UITableViewCell *edtCell = (id)[tableView cellForRowAtIndexPath:indexPath];
   // [edtCell.valueHPicker becomeFirstResponder];
}
@end
