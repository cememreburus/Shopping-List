//
//  ALItem.m
//  Aklimda
//
//  Created by Cem Emre Burus on 24/04/13.
//  Copyright (c) 2013 Cem Emre Burus. All rights reserved.
//

#import "ALItem.h"

@implementation ALItem

#pragma mark -
#pragma mark NSCoding Protocol Methods
- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    
    if (self) {
        [self setUuid:[decoder decodeObjectForKey:@"uuid"]];
        [self setName:[decoder decodeObjectForKey:@"name"]];
        [self setPrice:[decoder decodeObjectForKey:@"price"]];
        [self setInShoppingList:[decoder decodeBoolForKey:@"inShoppingList"]];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.uuid forKey:@"uuid"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.price forKey:@"price"];
    [coder encodeBool:self.inShoppingList forKey:@"inShoppingList"];
}

#pragma mark -
#pragma mark Class Methods
+ (ALItem *)createItemWithName:(NSString *)name andPrice:(NSString *)price {
    // Initialize Item
    ALItem *item = [[ALItem alloc] init];
    
    // Configure Item
    [item setName:name];
    [item setPrice:price];
    [item setInShoppingList:NO];
    [item setUuid:[[NSUUID UUID] UUIDString]];
    
    return item;
}

@end
