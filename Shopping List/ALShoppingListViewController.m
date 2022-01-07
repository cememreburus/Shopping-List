//
//  ALShoppingListViewController.m
//  Aklimda
//
//  Created by Cem Emre Burus on 24/04/13.
//  Copyright (c) 2013 Cem Emre Burus. All rights reserved.
//

#import "ALShoppingListViewController.h"

#import "ALItem.h"

@interface ALShoppingListViewController ()

@property (nonatomic) NSArray *items;
@property (nonatomic) NSArray *shoppingList;

@end

@implementation ALShoppingListViewController

#pragma mark -
#pragma mark Initialization
- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    
    if (self) {
        // Set Title
        self.title = @"Alışveriş Listem";
        
        // Load Items
        [self loadItems];
        
        // Add Observer
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateShoppingList:) name:@"ALShoppingListDidChangeNotification" object:nil];
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
#pragma mark Setters and Getters
- (void)setItems:(NSArray *)items {
    if (_items != items) {
        _items = items;
        
        // Build Shopping List
        [self buildShoppingList];
    }
}

- (void)setShoppingList:(NSArray *)shoppingList {
    if (_shoppingList != shoppingList) {
        _shoppingList = shoppingList;
        
        // Reload Table View
        [self.tableView reloadData];
    }
}

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.shoppingList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell Identifier";
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Fetch Item
    ALItem *item = [self.shoppingList objectAtIndex:[indexPath row]];
    
    // Configure Cell
    [cell.textLabel setText:[item name]];
    
    return cell;
}

#pragma mark -
#pragma mark Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark -
#pragma mark Notification Handling
- (void)updateShoppingList:(NSNotification *)notification {
    // Load Items
    [self loadItems];
}

#pragma mark -
#pragma mark Helper Methods
- (void)loadItems {
    NSString *filePath = [self pathForItems];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        // self.items = [NSMutableArray arrayWithContentsOfFile:filePath];
        self.items = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    } else {
        self.items = [NSMutableArray array];
    }
}

- (void)buildShoppingList {
    NSMutableArray *buffer = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self.items count]; i++) {
        ALItem *item = [self.items objectAtIndex:i];
        
        if ([item inShoppingList]) {
            // Add Item to Buffer
            [buffer addObject:item];
        }
    }
    
    // Set Shopping List
    self.shoppingList = [NSArray arrayWithArray:buffer];
}

- (NSString *)pathForItems {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths lastObject];
    
    return [documents stringByAppendingPathComponent:@"items.plist"];
}

@end
