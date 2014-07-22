
#import <UIKit/UIKit.h>

@class PropertiesStore;
@interface ChooseIndicatorsController : UIViewController <UITableViewDelegate, UITableViewDataSource> 
{
    
    IBOutlet UITableView *indicatorsList;
    IBOutlet UIToolbar *tbNormal;
    IBOutlet UIToolbar *tbEditing;
    IBOutlet UIBarButtonItem *btnClose;
    IBOutlet UIBarButtonItem *btnEdit;
    IBOutlet UIBarButtonItem *lblCaption1;
    IBOutlet UIBarButtonItem *lblCaption2;
    IBOutlet UIBarButtonItem *btnDone;
    IBOutlet UIBarButtonItem *btnAdd;
    PropertiesStore* default_properties;
    PropertiesStore* properties;

}
- (void)ShowIndicators:(PropertiesStore*)store AndDefStore:(PropertiesStore*)def_store;
- (void)indEditDlgClosed:(NSNotification *)notification;
- (void)indListSelected:(NSNotification *)notification;
- (IBAction)btnClosePressed:(id)sender;
- (IBAction)btnEditPressed:(id)sender;
- (IBAction)btnAddPressed:(id)sender; 
- (bool)IsMainIndSection:(int)section;

@property (nonatomic, retain)	PropertiesStore* default_properties;
@property (nonatomic, retain)	PropertiesStore* properties;
@property (nonatomic, retain)	UITableView* indicatorsList;
@property (nonatomic, retain)	UIToolbar* tbNormal;
@property (nonatomic, retain)	UIToolbar* tbEditing;
@property (nonatomic, retain)	UIBarButtonItem* btnClose;
@property (nonatomic, retain)	UIBarButtonItem* btnEdit;
@property (nonatomic, retain)	UIBarButtonItem* lblCaption1;
@property (nonatomic, retain)	UIBarButtonItem* lblCaption2;
@property (nonatomic, retain)	UIBarButtonItem* btnDone;
@property (nonatomic, retain)	UIBarButtonItem *btnAdd;

@end
