//
//  ALAddItemViewController.h
//  Aklimda
//
//  Created by Cem Emre Burus on 24/04/13.
//  Copyright (c) 2013 Cem Emre Burus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ALAddItemViewControllerDelegate;

@interface ALAddItemViewController : UIViewController

@property (weak) id<ALAddItemViewControllerDelegate> delegate;

@property IBOutlet UITextField *nameTextField;
@property IBOutlet UITextField *priceTextField;

@end

@protocol ALAddItemViewControllerDelegate <NSObject>
- (void)controller:(ALAddItemViewController *)controller didSaveItemWithName:(NSString *)name andPrice:(NSString *)price;
@end
