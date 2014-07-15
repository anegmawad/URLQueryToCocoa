/*
 This file will become a part of the OCFWebServer, which is a part of Objective-Cloud.
 
 Copyright (c) 2014, Amin Negm-Awad / amin@objective-cloud.com
 All rights reserved.
 
*/

#import <Foundation/Foundation.h>

@interface NSDictionary (OCFURLQuery)
+ (void)setDefaultURLQueryKeyPrefix:(NSString*)delimiter;
+ (NSString*)defaultURLQueryKeyPrefix;
+ (void)setDefaultURLQueryKeyPostfix:(NSString*)delimiter;
+ (NSString*)defaultURLQueryKeyPostfix;
+ (void)setDefaultURLQueryPairsDelimiter:(NSString*)delimiter;
+ (NSString*)defaultURLQueryPairsDelimiter;

+ (NSDictionary*)objectsFromURLQueryString:(NSString*)query;
+ (NSDictionary*)objectsFromURLQueryString:(NSString*)query withPairsDelimiter:(NSString*)delimiter keyPrefix:(NSString*)keyPrefix keyPostFix:(NSString*)keyPostfix;
@end

@interface NSMutableDictionary (OCFURLQuery)
- (void)setObject:(NSString*)value forURLQueryKeyPath:(NSString*)keyPath;
- (void)setObject:(NSString*)value forURLQueryKeyPath:(NSString*)keyPath keyPrefix:(NSString*)keyPrefix keyPostfix:(NSString*)keyPostfix;
@end
