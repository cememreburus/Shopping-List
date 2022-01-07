//
//  ALAddItemViewController.m
//  Aklimda
//
//  Created by Cem Emre Burus on 24/04/13.
//  Copyright (c) 2013 Cem Emre Burus. All rights reserved.
//

#import "ALAddItemViewController.h"

@interface ALAddItemViewController ()

@end

@implementation ALAddItemViewController

#pragma mark -
#pragma mark Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
    }
    
    return self;
}

#pragma mark -
#pragma mark View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark Actions
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender {
    // Extract User Input
    NSString *name = [self.nameTextField text];
    NSString *price = [self.priceTextField text];
    
    // Notify Delegate
    [self.delegate controller:self didSaveItemWithName:name andPrice:price];
    
    // Dismiss View Controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
