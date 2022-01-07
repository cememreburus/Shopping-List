//
//  ALListViewController.h
//  Aklimda
//
//  Created by Cem Emre Burus on 24/04/13.
//  Copyright (c) 2013 Cem Emre Burus. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ALAddItemViewController.h"
#import "ALEditItemViewController.h"

@interface ALListViewController : UITableViewController <ALAddItemViewControllerDelegate, ALEditItemViewControllerDelegate>

@end
