//
//  CB_NSNull+JSON.m
//  CrowdBox
//
//  Created by Koby Hastings on 11/29/14.
//  Copyright (c) 2014 CrowdBox, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSNull (JSON)
@end

@implementation NSNull (JSON)

- (NSUInteger)length { return 0; }

- (NSInteger)integerValue { return 0; };

- (float)floatValue { return 0; };

- (NSString *)description { return @"0(NSNull)"; }

- (NSArray *)componentsSeparatedByString:(NSString *)separator { return @[]; }

- (id)objectForKey:(id)key { return nil; }

- (BOOL)boolValue { return NO; }

@end