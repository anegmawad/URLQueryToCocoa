/*
 This file will become a part of OCFWebServer, which is a part of Objective-Cloud.
 
 Copyright (c) 2014, Amin Negm-Awad / amin@objective-cloud.com
 All rights reserved.
 
 */

#import "OCFURLQuery.h"


@interface NSString (QueryToObject)
- (BOOL)IsURLQueryIndex;
@end

@implementation NSString (QueryToObject)
- (BOOL)IsURLQueryIndex
{
	unichar firstLetter = [self characterAtIndex:0];
	return (firstLetter>='0') && (firstLetter<='9');
}
@end

@interface NSMutableArray (OCFQueryKVC)
- (void)setObject:(id)object forURLQueryKey:(NSString*)key;
- (id)objectForURLQueryKey:(NSString*)key;
@end

@implementation NSMutableArray (OCFQueryKVC)
- (void)setObject:(id)object forURLQueryKey:(NSString*)key
{
	NSUInteger index = [key integerValue];
	NSUInteger fillUpIndex = [self count];
	
	while (fillUpIndex++<=index)
	{
		[self addObject:[NSNull null]];
	}
	self[index] = object;
}

- (id)objectForURLQueryKey:(NSString*)key
{
	NSUInteger index = [key integerValue];
	id object = [NSNull null];
	if ([self count]<=index)
	{
		[self setObject:object forURLQueryKey:key];
	}
	else
	{
		object = self[index];
	}
	return object;
}
@end

@interface NSMutableDictionary (OCFURLQueryKVC)
- (void)setObject:(id)object forURLQueryKey:(NSString*)key;
- (id)objectForURLQueryKey:(NSString*)key;
@end

@implementation NSMutableDictionary (OCFURLQueryKVC)
- (void)setObject:(id)object forURLQueryKey:(NSString*)key
{
	self[key]=object;
}

- (id)objectForURLQueryKey:(NSString*)key
{
	id object = self[key];
	if (object==nil)
	{
		object = [NSNull null];
		self[key]=object;
	}
	return object;
}
@end

@implementation NSMutableDictionary (OCFURLQuery)

- (void)setObject:(NSString*)value forURLQueryKeyPath:(NSString*)keyPath keyPrefix:(NSString*)keyPrefix keyPostfix:(NSString*)keyPostfix
{
	value = [value  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

	keyPath = [keyPath stringByReplacingOccurrencesOfString:keyPostfix withString:@""];
	NSArray *keys = [keyPath componentsSeparatedByString:keyPrefix];
	
	NSAssert([keys count]>0, @"no components at all!?!?!?!");
	
	NSUInteger keyIndex = 0;
	id omi = nil;
	id parent = nil;
	id node = self;

	NSString *key;
	NSString *parentKey;
	while (keyIndex<([keys count]-1))
	{
		parentKey = key;
		key = keys[keyIndex++];
		key = [key stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		
		omi = parent;
		parent = node;

		Class collectionClass;
		if ([key IsURLQueryIndex])
		{
			collectionClass = [NSMutableArray class];
		}
		else
		{
			collectionClass = [NSMutableDictionary class];
		}
			
		if ([parent isKindOfClass:[NSNull class]])
		{
			parent = [collectionClass new];
			[omi setObject:parent forURLQueryKey:parentKey];
		}

		else if (![parent isKindOfClass:collectionClass])
		{
			return;
		}
		node = [parent objectForURLQueryKey:key];
	}
	parentKey = key;
	key = keys[keyIndex];
	if ([key IsURLQueryIndex])
	{
		if ([node isKindOfClass:[NSNull class]]) {
			node =[NSMutableArray new];
			[parent setObject:node forURLQueryKey:parentKey];
		}
	}
	else
	{
		if ([node isKindOfClass:[NSNull class]])
		{
			node = [NSMutableDictionary new];
			[parent setObject:node forURLQueryKey:parentKey];
		}
	}
	[node setObject:value forURLQueryKey:key];
}

- (void)setObject:(NSString*)value forURLQueryKeyPath:(NSString*)keyPath
{
	[self setObject:value forURLQueryKeyPath:keyPath keyPrefix:[[self class] defaultURLQueryKeyPrefix] keyPostfix:[[self class] defaultURLQueryKeyPostfix]];
}
@end

@implementation NSDictionary (OCFURLQuery)

static NSString *_keyPrefix = @"[";

+ (void)setDefaultURLQueryKeyPrefix:(NSString*)delimiter
{
	_keyPrefix = delimiter;
}

+ (NSString*)defaultURLQueryKeyPrefix
{
	return _keyPrefix;
}

static NSString *_keyPostfix = @"]";

+ (void)setDefaultURLQueryKeyPostfix:(NSString*)delimiter
{
	_keyPostfix = delimiter;
}

+ (NSString*)defaultURLQueryKeyPostfix
{
	return _keyPostfix;
}

static NSString *_delimiter = @"&";

+ (NSString*)defaultURLQueryPairsDelimiter
{
	return _delimiter;
}

+ (void)setDefaultURLQueryPairsDelimiter:(NSString*)delimiter
{
	_delimiter = delimiter;
}

+ (NSDictionary*)objectsFromURLQueryString:(NSString*)query
{
	return [self objectsFromURLQueryString:query withPairsDelimiter:[self defaultURLQueryPairsDelimiter] keyPrefix:[self defaultURLQueryKeyPrefix] keyPostFix:[self defaultURLQueryKeyPostfix]];
}

+ (NSDictionary*)objectsFromURLQueryString:(NSString*)query withPairsDelimiter:(NSString*)delimiter keyPrefix:(NSString*)keyPrefix keyPostFix:(NSString*)keyPostfix
{
	NSArray *assignments = [query componentsSeparatedByString:delimiter];
	
	NSMutableDictionary *keyValuePairs = [NSMutableDictionary new];
	for (NSString *assignment in assignments)
	{
		NSUInteger equalsSignLocation = [assignment rangeOfString:@"="].location;
		if (equalsSignLocation==NSNotFound)
		{
			return nil;
		}
		
		NSString *keyPath = [assignment substringToIndex:equalsSignLocation];
		NSString *value = [assignment substringFromIndex:equalsSignLocation+1];
		value = [value stringByRemovingPercentEncoding];
		if (value==nil) {
			value = @"";
		}

		
		[keyValuePairs setObject:value forURLQueryKeyPath:keyPath keyPrefix:keyPrefix keyPostfix:keyPostfix];
		
	}
	return keyValuePairs;
}

@end
