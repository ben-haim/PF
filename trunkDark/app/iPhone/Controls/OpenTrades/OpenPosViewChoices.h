//
//  WEPopoverContentViewController.h
//  WEPopover
//
//  Created by Werner Altewischer on 06/11/10.
//  Copyright 2010 Werner IT Consultancy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParamsStorage.h"


@class OpenPosWatch;

@interface OpenPosViewChoices : UITableViewController 
{

}

@property (nonatomic, retain) OpenPosWatch *ParentController;
@property (nonatomic, assign) OpenTradesViewType CurrentView;
@property (retain, nonatomic) NSArray *ViewChoices;

@end
