//
//  SVDBManagerTest.m
//  SPUIView
//
//  Created by Rain on 2/12/16.
//  Copyright © 2016 chinasofti. All rights reserved.
//

#import "SVDBManager.h"
#import "SVJunitTestTable.h"
#import <XCTest/XCTest.h>

@interface SVDBManagerTest : XCTestCase


@end

@implementation SVDBManagerTest

- (void)testInitDB
{
    SVDBManager *db = [SVDBManager sharedInstance];
    NSString *sql =
    @"create table  if not exists SVJunitTestTable(id integer primary key autoincrement,testId "
    @"integer, name text, isOK integer); ";
    [db executeUpdate:sql];
}

- (void)testExecuteQuery
{
    SVDBManager *db = [SVDBManager sharedInstance];
    NSArray *array =
    [db executeQuery:[SVJunitTestTable class] SQL:@"select * from SVJunitTestTable;"];
    NSAssert (array.count != 0, @"execute query fail.");
    SVJunitTestTable *junitTestTable = [array objectAtIndex:0];
    NSLog (@"junitTestTable id:%@", [junitTestTable id]);
    NSLog (@"junitTestTable name:%@", [junitTestTable name]);
}

@end
