#import <UIKit/UIKit.h>

@protocol PFCountriesViewControllerDelegate;

@interface PFCountriesViewController : UITableViewController

@property ( nonatomic, weak ) id< PFCountriesViewControllerDelegate > delegate;

@end

@class PFCountry;

@protocol PFCountriesViewControllerDelegate <NSObject>

-(void)countriesController:( PFCountriesViewController* )controller_
          didSelectCountry:( PFCountry* )country_;

@end
