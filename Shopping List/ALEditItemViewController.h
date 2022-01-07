//
//  ALEditItemViewController.h
//  Aklimda
//
//  Created by Cem Emre Burus on 24/04/13.
//  Copyright (c) 2013 Cem Emre Burus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALItem;
@protocol ALEditItemViewControllerDelegate;

@interface ALEditItemViewController : UIViewController

@property IBOutlet UITextField *nameTextField;
@property IBOutlet UITextField *priceTextField;

#pragma mark -
#pragma mark Initialization
- (id)initWithItem:(ALItem *)item andDelegate:(id<ALEditItemViewControllerDelegate>)delegate;

@end

@protocol ALEditItemViewControllerDelegate <NSObject>
- (void)controller:(ALEditItemViewController *)controller didUpdateItem:(ALItem *)item;
@end
