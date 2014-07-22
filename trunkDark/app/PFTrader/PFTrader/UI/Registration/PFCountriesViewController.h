#import <UIKit/UIKit.h>

@protocol PFCountriesViewControllerDelegate;

@interface PFCountriesViewController : UITableViewController

@property ( nonatomic, unsafe_unretained ) id< PFCountriesViewControllerDelegate > delegate;

@end

@class PFCountry;

@protocol PFCountriesViewControllerDelegate <NSObject>

-(void)countriesController:( PFCountriesViewController* )controller_
          didSelectCountry:( PFCountry* )country_;

@end
