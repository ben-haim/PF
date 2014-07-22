#import "PFTableViewCategory+Registration.h"

#import "PFTableViewBasePickerItem.h"
#import "PFTableViewSwitchItem.h"
#import "PFTableViewDetailItem.h"
#import "PFTableViewPickerItem.h"

#import "PFTableViewDetailItemCell.h"

#import "PFRegistrationViewController.h"
#import "PFCountriesViewController.h"
#import "PFCountry.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFTableViewCountryItem : PFTableViewDetailItem< PFCountriesViewControllerDelegate >

@property ( nonatomic, strong ) PFCountry* country;

@end

@implementation PFTableViewCountryItem

@synthesize country;

-(void)countriesController:( PFCountriesViewController* )controller_
          didSelectCountry:( PFCountry* )country_
{
   self.country = country_;
   self.value = country_.name;

   PFTableViewDetailItemCell* cell_ = ( PFTableViewDetailItemCell* )self.cell;
   cell_.valueLabel.text = self.value;
}

@end

@implementation PFTableViewCategory (Registration)

+(NSArray*)registrationCategoriesWithController:( PFRegistrationViewController* )controller_
{
   __unsafe_unretained PFRegistrationViewController* weak_controller_ = controller_;

   PFTableViewEditableDetailItem* login_item_ = [ PFTableViewEditableDetailItem itemWithAction: nil
                                                                                         title: NSLocalizedString( @"LOGIN", nil ) ];

   login_item_.applier = ^( id item_, id object_ )
   {
      PFDemoAccount* account_ = ( PFDemoAccount* )object_;
      account_.login = [ ( PFTableViewEditableDetailItem* )item_ value ];
   };
   
   id login_category_ = [ self categoryWithTitle: nil  items: @[login_item_] ];
   
   PFTableViewEditableDetailItem* password_item_ = [ PFTableViewEditableDetailItem itemWithAction: nil
                                                                                            title: NSLocalizedString( @"PASSWORD", nil ) ];
   password_item_.secureTextEntry = YES;
   password_item_.applier = ^( id item_, id object_ )
   {
      PFDemoAccount* account_ = ( PFDemoAccount* )object_;
      account_.password = [ ( PFTableViewEditableDetailItem* )item_ value ];
   };

   PFTableViewEditableDetailItem* confirm_password_item_ = [ PFTableViewEditableDetailItem itemWithAction: nil
                                                                                                    title: NSLocalizedString( @"CONFIRM_PASSWORD", nil ) ];

   confirm_password_item_.secureTextEntry = YES;
   confirm_password_item_.applier = ^( id item_, id object_ )
   {
      PFDemoAccount* account_ = ( PFDemoAccount* )object_;
      account_.confirmedPassword = [ ( PFTableViewEditableDetailItem* )item_ value ];
   };
   
   id password_category_ = [ self categoryWithTitle: nil  items: @[password_item_, confirm_password_item_] ];
   
   PFTableViewEditableDetailItem* first_name_item_ = [ PFTableViewEditableDetailItem itemWithAction: nil
                                                                                            title: NSLocalizedString( @"FIRST_NAME", nil ) ];
   first_name_item_.applier = ^( id item_, id object_ )
   {
      PFDemoAccount* account_ = ( PFDemoAccount* )object_;
      account_.firstName = [ ( PFTableViewEditableDetailItem* )item_ value ];
   };

   PFTableViewEditableDetailItem* last_name_item_ = [ PFTableViewEditableDetailItem itemWithAction: nil
                                                                                             title: NSLocalizedString( @"LAST_NAME", nil ) ];
   last_name_item_.applier = ^( id item_, id object_ )
   {
      PFDemoAccount* account_ = ( PFDemoAccount* )object_;
      account_.lastName = [ ( PFTableViewEditableDetailItem* )item_ value ];
   };
   
   id name_category_ = [ self categoryWithTitle: nil  items: @[first_name_item_, last_name_item_] ];
   
   PFTableViewCountryItem* country_item_ = [ PFTableViewCountryItem itemWithAction: nil
                                                                             title: NSLocalizedString( @"COUNTRY", nil )
                                                                             value: nil ];

   country_item_.action = ^( PFTableViewItem* item_ )
   {
      PFCountriesViewController* countries_controller_ = [ PFCountriesViewController new ];
      countries_controller_.delegate = ( PFTableViewCountryItem* )item_;
      [ weak_controller_.navigationController pushViewController: countries_controller_ animated: YES ];
   };

   country_item_.applier = ^( id item_, id object_ )
   {
      PFDemoAccount* account_ = ( PFDemoAccount* )object_;
      account_.countryId = (PFInteger)[ ( PFTableViewCountryItem* )item_ country ].countryId;
   };
   
   country_item_.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
   
   id country_category_ = [ self categoryWithTitle: nil  items: @[country_item_] ];

   PFTableViewEditableDetailItem* phone_item_ = [ PFTableViewEditableDetailItem itemWithAction: nil
                                                                                         title: NSLocalizedString( @"PHONE", nil )
                                                                                         value: nil
                                                                                   placeholder: nil
                                                                                  keyboardType: UIKeyboardTypePhonePad ];
   
   
   phone_item_.applier = ^( id item_, id object_ )
   {
      PFDemoAccount* account_ = ( PFDemoAccount* )object_;
      account_.phone = [ ( PFTableViewEditableDetailItem* )item_ value ];
   };

   id phone_category_ = [ self categoryWithTitle: nil  items: @[phone_item_] ];
   
   PFTableViewEditableDetailItem* email_item_ = [ PFTableViewEditableDetailItem itemWithAction: nil
                                                                                         title: NSLocalizedString( @"EMAIL", nil )
                                                                                         value: nil
                                                                                   placeholder: nil
                                                                                  keyboardType: UIKeyboardTypeEmailAddress ];

   email_item_.applier = ^( id item_, id object_ )
   {
      PFDemoAccount* account_ = ( PFDemoAccount* )object_;
      account_.email = [ ( PFTableViewEditableDetailItem* )item_ value ];
   };

   id email_category_ = [ self categoryWithTitle: nil  items: @[email_item_] ];
   
   PFTableViewChoicesPickerItem* currency_item_ = [ PFTableViewChoicesPickerItem itemWithAction: nil
                                                                                          title: NSLocalizedString( @"ACCOUNT_CURRENCY", nil ) ];

   currency_item_.choices = @[ @"USD", @"EUR", @"GBP" ];
   currency_item_.applier = ^( id item_, id object_ )
   {
      PFDemoAccount* account_ = ( PFDemoAccount* )object_;
      account_.currency = [ (PFTableViewChoicesPickerItem*)item_ value ];
   };

   PFTableViewChoicesPickerItem* balance_item_ = [ PFTableViewChoicesPickerItem itemWithAction: nil
                                                                                         title: NSLocalizedString( @"DEMO_ACCOUNT_BALANCE", nil ) ];


   balance_item_.choices = @[ @"1000", @"5000", @"10000", @"50000", @"100000" ];

   balance_item_.applier = ^( id item_, id object_ )
   {
      PFDemoAccount* account_ = ( PFDemoAccount* )object_;
      account_.balance = [ [ ( PFTableViewChoicesPickerItem* )item_ value ] integerValue ];
   };

   PFTableViewSwitchItem* position_item_ = [ PFTableViewSwitchItem switchItemWithTitle: NSLocalizedString( @"ONE_POSITION_PER_INSTRUMENT", nil )
                                                                                  isOn: YES
                                                                          switchAction: nil ];

   position_item_.applier = ^( id item_, id object_ )
   {
      PFDemoAccount* account_ = ( PFDemoAccount* )object_;
      account_.isOnePosition = [ ( PFTableViewSwitchItem* )item_ on ];
   };

   id balance_category_ = [ self categoryWithTitle: nil  items: @[currency_item_, balance_item_, position_item_] ];
   
   return @[login_category_
           , password_category_
           , name_category_
           , country_category_
           , phone_category_
           , email_category_
           , balance_category_];
}

@end
