//
//  ALItem.h
//  Aklimda
//
//  Created by Cem Emre Burus on 24/04/13.
//  Copyright (c) 2013 Cem Emre Burus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALItem : NSObject <NSCoding>

@property NSString *uuid;
@property NSString *name;
@property NSString *price;
@property BOOL inShoppingList;

#pragma mark -
#pragma mark Class Methods
+ (ALItem *)createItemWithName:(NSString *)name andPrice:(NSString *)price;

@end
