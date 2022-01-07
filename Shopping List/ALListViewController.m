//
//  ALListViewController.m
//  Aklimda
//
//  Created by Cem Emre Burus on 24/04/13.
//  Copyright (c) 2013 Cem Emre Burus. All rights reserved.
//

#import "ALListViewController.h"

#import "ALItem.h"
#import "ALEditItemViewController.h"

@interface ALListViewController ()

@property NSMutableArray *items;

@end

@implementation ALListViewController

#pragma mark -
#pragma mark Initialization
- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    
    if (self) {
        // Set Title
        self.title = @"Öğeler";
        
        // Load Items
        [self loadItems];
    }
    
    return self;
}

#pragma mark -
#pragma mark View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create Add Button
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editItems:)];

    NSLog(@"Items > %@", self.items);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell Identifier";
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Fetch Item
    ALItem *item = [self.items objectAtIndex:[indexPath row]];
    
    // Configure Cell
    [cell.textLabel setText:[item name]];
    [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];

    // Show/Hide Checkmark
    if ([item inShoppingList]) {
        [cell.imageView setImage:[UIImage imageNamed:@"checkmark"]];
    } else {
        [cell.imageView setImage:nil];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    if ([indexPath row] == 1) {
        return NO;
    }
    */
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete Item from Items
        [self.items removeObjectAtIndex:[indexPath row]];
        
        // Update Table View
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
        // Save Changes to Disk
        [self saveItems];
    }
}

#pragma mark -
#pragma mark Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Fetch Item
    ALItem *item = [self.items objectAtIndex:[indexPath row]];
    
    // Update Item
    [item setInShoppingList:![item inShoppingList]];
    
    // Update Cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([item inShoppingList]) {
        [cell.imageView setImage:[UIImage imageNamed:@"checkmark"]];
    } else {
        [cell.imageView setImage:nil];
    }
    
    // Save Items
    [self saveItems];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    // Fetch Item
    ALItem *item = [self.items objectAtIndex:[indexPath row]];
    
    // Initialize Edit Item View Controller
    ALEditItemViewController *editItemViewController = [[ALEditItemViewController alloc] initWithItem:item andDelegate:self];
    
    // Push View Controller onto Navigation Stack
    [self.navigationController pushViewController:editItemViewController animated:YES];
}

#pragma mark -
#pragma mark Add Item View Controller Delegate Methods
- (void)controller:(ALAddItemViewController *)controller didSaveItemWithName:(NSString *)name andPrice:(NSString *)price {
    // Create Item
    ALItem *item = [ALItem createItemWithName:name andPrice:price];
    
    // Add Item to Data Source
    [self.items addObject:item];
    
    // Add Row to Table View
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:([self.items count] - 1) inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    // Save Items
    [self saveItems];
}

#pragma mark -
#pragma mark Edit Item View Controller Delegate Methods
- (void)controller:(ALEditItemViewController *)controller didUpdateItem:(ALItem *)item {
    // Fetch Item
    for (int i = 0; i < [self.items count]; i++) {
        ALItem *anItem = [self.items objectAtIndex:i];
        
        if ([[anItem uuid] isEqualToString:[item uuid]]) {
            // Update Table View Row
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    
    // Save Items
    [self saveItems];
}

#pragma mark -
#pragma mark Actions
- (void)addItem:(id)sender {
    // Initialize Add Item View Controller
    ALAddItemViewController *addItemViewController = [[ALAddItemViewController alloc] initWithNibName:@"ALAddItemViewController" bundle:nil];
    
    // Set Delegate
    [addItemViewController setDelegate:self];
    
    // Present View Controller
    [self presentViewController:addItemViewController animated:YES completion:nil];
}

- (void)editItems:(id)sender {
    [self.tableView setEditing:![self.tableView isEditing] animated:YES];
}

#pragma mark -
#pragma mark Helper Methods
- (void)loadItems {
    NSString *filePath = [self pathForItems];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        self.items = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    } else {
        self.items = [NSMutableArray array];
    }
}

- (void)saveItems {
    NSString *filePath = [self pathForItems];
    [NSKeyedArchiver archiveRootObject:self.items toFile:filePath];
    
    // Post Notification
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ALShoppingListDidChangeNotification" object:self];
}

- (NSString *)pathForItems {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths lastObject];
    
    return [documents stringByAppendingPathComponent:@"items.plist"];
}

@end
