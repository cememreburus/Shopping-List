//
//  ALEditItemViewController.m
//  Aklimda
//
//  Created by Cem Emre Burus on 24/04/13.
//  Copyright (c) 2013 Cem Emre Burus. All rights reserved.
//

#import "ALEditItemViewController.h"

#import "ALItem.h"

@interface ALEditItemViewController ()

@property ALItem *item;
@property (weak) id<ALEditItemViewControllerDelegate> delegate;

@end

@implementation ALEditItemViewController

#pragma mark -
#pragma mark Initialization
- (id)initWithItem:(ALItem *)item andDelegate:(id<ALEditItemViewControllerDelegate>)delegate {
    self = [super initWithNibName:@"ALEditItemViewController" bundle:nil];
    
    if (self) {
        // Set Item
        self.item = item;
        
        // Set Delegate
        self.delegate = delegate;
    }
    
    return self;
}

#pragma mark -
#pragma mark View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create Save Button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
    
    // Populate Text Fields
    if (self.item) {
        [self.nameTextField setText:[self.item name]];
        [self.priceTextField setText:[NSString stringWithFormat:@"%@", [self.item price]]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark Actions
- (void)save:(id)sender {
    NSString *name = [self.nameTextField text];
    NSString *price = [self.priceTextField text];
    
    // Update Item
    [self.item setName:name];
    [self.item setPrice:price];
    
    // Notify Delegate
    [self.delegate controller:self didUpdateItem:self.item];
    
    // Pop View Controller
    [self.navigationController popViewControllerAnimated:YES];
}

@end
