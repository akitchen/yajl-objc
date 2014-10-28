//
//  PerfTest.m
//  YAJL
//
//  Created by Gabriel Handford on 6/29/09.
//  Copyright 2009. All rights reserved.
//

#import "NSString+SBJSON.h"

@interface PerfTest : YAJLTestCase {}
@end

@implementation PerfTest

#define kPerfTestCount 200

- (void)testYAJLParser {
  NSString *examplePath = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"json"];
  NSData *data = [[NSData dataWithContentsOfFile:examplePath options:NSUncachedRead error:nil] retain]; 
  
  NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
  for(NSInteger i = 0; i < kPerfTestCount; i++) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    YAJLParser *parser = [[YAJLParser alloc] initWithParserOptions:YAJLParserOptionsNone];
    if (![parser parse:data]) GHFail(@"Failed to parse: %@", parser.parserError);   
    [parser release];
    [pool release];
  }
  NSTimeInterval took = [NSDate timeIntervalSinceReferenceDate] - start;
  GHTestLog(@"Took %0.4f sec", took);
  [data release];
}

- (void)testSBJSON {
  NSString *examplePath = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"json"];
  NSData *testData = [NSData dataWithContentsOfFile:examplePath options:NSUncachedRead error:nil];
  NSString *testString = [[NSString alloc] initWithData:testData encoding:NSUTF8StringEncoding];
  
  NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
  for(NSInteger i = 0; i < kPerfTestCount; i++) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    id value = [testString JSONValue];    
    if (!value) GHFail(@"No result");
    [pool release];   
  }
  NSTimeInterval took = [NSDate timeIntervalSinceReferenceDate] - start;
  GHTestLog(@"Took %0.4f", took);
  
  [testString release];
  
}

- (void)testNSJSONSerialization {
    NSString *examplePath = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"json"];
    NSData *testData = [NSData dataWithContentsOfFile:examplePath options:NSUncachedRead error:nil];

    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    for(NSInteger i = 0; i < kPerfTestCount; i++) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        id value = [NSJSONSerialization JSONObjectWithData:testData options:0 error:NULL];
        if (!value) GHFail(@"No result");
        [pool release];
    }
    NSTimeInterval took = [NSDate timeIntervalSinceReferenceDate] - start;
    GHTestLog(@"Took %0.4f", took);
}

@end
