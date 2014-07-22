#import "PFDecimalPadView.h"
#import "PFButton.h"

#import "NSString+DoubleFormatter.h"
#import "UILabel+Price.h"
#import "UIColor+Skin.h"

static const int accountLabelsCount = 8;

@interface PFDecimalPadView () < PFSessionDelegate >

@property ( nonatomic, strong ) NSMutableArray* accountLabels;

@property (nonatomic, unsafe_unretained) id< PFDecimalPadViewDelegate > delegate;

-(PFGrayButton*)createButtonWithTag: (NSInteger)tag_;
-(void)reloadAccountData;

@end

@implementation PFDecimalPadView

@synthesize accountLabels;
@synthesize delegate;

+(id)createDecimalPadWithDelegate: (id< PFDecimalPadViewDelegate >)delegate_
{
   PFDecimalPadView* pad_view_ = [ [ PFDecimalPadView alloc ] initWithFrame: CGRectMake(0.0, 0.0, 320.0, 250.0) ];
   pad_view_.delegate = delegate_;
   
   return pad_view_;
}

- (id)initWithFrame:(CGRect)frame
{
   self = [ super initWithFrame: frame ];
   if ( self )
   {
      self.backgroundColor = [ UIColor darkGrayColor ];
      self.alpha = 1.f;
      
      for (int i = -1; i < 11; i++)
      {
         [ self createButtonWithTag: i ];
      }
   }
   return self;
}

-(void)buttonPressed: (PFGrayButton*)sender_
{
   if ( self.delegate )
   {
      [ self.delegate pressedButtonWithCode: (PFDecimalPadCodeType)sender_.tag ];
   }
}

-(UILabel*)createLabelWithIndex: (int)index_
{
   UILabel* label_ = [ UILabel new ];
   
   label_.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
   label_.frame = CGRectMake(45.0 + 170.0 * (index_ % 2), 25.0 + 59.0 * (index_ / 2), 150.0, 20.0);
   label_.backgroundColor = [ UIColor clearColor ];
   label_.textColor = [ UIColor mainTextColor ];
   
   [ self addSubview: label_ ];
   
   return label_;
}

-(PFGrayButton*)createButtonWithTag: (NSInteger)tag_
{
   int row_index_, column_index_;
   
   switch ( tag_ )
   {
      case 1 :
      case 4 :
      case 7 :
      case 10 :
         column_index_ = 0;
         break;
         
      case 2 :
      case 5 :
      case 8 :
      case 0 :
         column_index_ = 1;
         break;
         
      case 3 :
      case 6 :
      case 9 :
      case -1 :
         column_index_ = 2;
         break;
         
   }
   
   switch ( tag_ )
   {
      case 1 :
      case 2 :
      case 3 :
         row_index_ = 0;
         break;
         
      case 4 :
      case 5 :
      case 6 :
         row_index_ = 1;
         break;
         
      case 7 :
      case 8 :
      case 9 :
         row_index_ = 2;
         break;
         
      case 10 :
      case -1 :
      case 0 :
         row_index_ = 3;
         break;
         
   }
   
   PFGrayButton* button_ = [ [ PFGrayButton alloc ] initWithFrame: CGRectMake(44 + column_index_ * 80.0, 8 + row_index_ * 59.0, 72.0, 52.0) ];
   button_.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
   button_.tag = tag_;
   
   [ button_ setTitle: (tag_ == -1 ? @"⌫" : ( tag_ == 10 ? @"." : [ NSString stringWithFormat: @"%d", (int)tag_ ]))
             forState: UIControlStateNormal ];
   
   [ button_ addTarget: self
                action: @selector(buttonPressed:)
      forControlEvents: UIControlEventTouchUpInside ];
   
   [ self addSubview: button_ ];
   
   return button_;
}

-(void)reloadAccountData
{
   if ( self.accountLabels.count == 8 )
   {
      id< PFAccount > default_account_ = [ PFSession sharedSession ].accounts.defaultAccount;
      
      ((UILabel*)(self.accountLabels)[0]).text =  [ NSLocalizedString( @"ACCOUNT_NAME", nil ) stringByAppendingString: @":" ];
      ((UILabel*)(self.accountLabels)[1]).text = default_account_.name;
      ((UILabel*)(self.accountLabels)[2]).text = [ NSLocalizedString( @"ACCOUNT_BALANCE", nil ) stringByAppendingString: @":" ];
      ((UILabel*)(self.accountLabels)[3]).text = [ NSString stringWithFormat: @"%@ %@",
                                                                  [ NSString stringWithMoney: default_account_.balance ]
                                                                  , default_account_.currency ];
      ((UILabel*)(self.accountLabels)[4]).text = [ NSLocalizedString( @"OPEN_NET_PL", nil ) stringByAppendingString: @":" ];
      [(UILabel*)(self.accountLabels)[5]  showColouredValue: default_account_.totalNetPl precision: 2 suffix: default_account_.currency  ];
      ((UILabel*)(self.accountLabels)[6]).text = [ NSLocalizedString( @"CURRENT_MARGIN", nil ) stringByAppendingString: @":" ];
      ((UILabel*)(self.accountLabels)[7]).text = [ NSString stringWithPercent: default_account_.currentMargin showPercentSign: YES ];
   }
}

-(void)willMoveToSuperview:(UIView*)newSuperview_
{
   if ( UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad )
      return;
   
   if ( newSuperview_ )
   {
      self.accountLabels = [ NSMutableArray arrayWithCapacity: accountLabelsCount ];
      for (int i = 0; i < accountLabelsCount; i++)
      {
         [ self.accountLabels addObject: [ self createLabelWithIndex: i ] ];
      }
      
      [ self reloadAccountData ];
      
      [ [ PFSession sharedSession ] addDelegate: self ];
   }
   else
   {
      for (UILabel* label_ in  self.accountLabels )
      {
         [ label_ removeFromSuperview ];
      }
      
      [ self.accountLabels removeAllObjects ];
      [ [ PFSession sharedSession ] removeDelegate: self ];
   }
   
   [ super willMoveToSuperview: newSuperview_ ];
}

#pragma mark  - PFSessionDelegate

-(void)session:( PFSession* )session_
didUpdateAccount:( id< PFAccount > )account_
{
   [ self reloadAccountData ];
}

@end
