
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

@property (nonatomic, strong)	PropertiesStore* default_properties;
@property (nonatomic, strong)	PropertiesStore* properties;
@property (nonatomic, strong)	UITableView* indicatorsList;
@property (nonatomic, strong)	UIToolbar* tbNormal;
@property (nonatomic, strong)	UIToolbar* tbEditing;
@property (nonatomic, strong)	UIBarButtonItem* btnClose;
@property (nonatomic, strong)	UIBarButtonItem* btnEdit;
@property (nonatomic, strong)	UIBarButtonItem* lblCaption1;
@property (nonatomic, strong)	UIBarButtonItem* lblCaption2;
@property (nonatomic, strong)	UIBarButtonItem* btnDone;
@end
