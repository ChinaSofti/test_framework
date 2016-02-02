//
//  SVDBManager.m
//  SPUIView
//
//  Created by XYB on 16/1/30.
//  Copyright © 2016年 chinasofti. All rights reserved.
//

#import "FMDatabase.h"
#import "FMResultSet.h"
#import "SVDBManager.h"
#import "SVSummaryResultModel.h"


@implementation SVDBManager

{
    //表示数据库
    FMDatabase *_dataBase;
}

+ (id)defaultDBManager
{
    static SVDBManager *manager = nil;
    if (manager == nil)
    {
        manager = [[SVDBManager alloc] init];
    }
    return manager;
}

- (id)init
{
    if (self = [super init])
    {
        // A、创建数据库
        [self createDataBase];
    }
    return self;
}
// A、创建数据库
- (void)createDataBase
{ // 1、指定数据库的位置

    NSString *path = NSHomeDirectory ();
    NSString *dbpath = [path stringByAppendingPathComponent:@"Library/Caches/SummaryResult"];
    // Documents/SummaryResult

    // 2、在这个位置创建一个数据库
    if (_dataBase == nil)
    {
        _dataBase = [FMDatabase databaseWithPath:dbpath];
    }
    // 3、操作数据库之前 一定要打开数据库、否则所有的操作都无法执行
    [_dataBase open];

    // B、创建表单
    [self createTable];
}
// B、创建表单
- (void)createTable
{

    NSString *sql = @"create table SVSummaryResultModel(ID integer primary key autoincrement,testId text,type text,date text,time text, testTime text,UvMOS text,loadTime text,bandwidth text); ";

    //    数据库对象执行sql语句
    [_dataBase executeUpdate:sql];
}

/**
 *  增
 *
 *  @param SVTest
 */
- (void)addSVSummaryResultModel:(SVSummaryResultModel *)test
{
    NSString *sql = @"insert into SVSummaryResultModel(testId,type,date,time,testTime,UvMOS,loadTime,bandwidth) values(?,?,?,?,?,?,?,?);";

    //延迟插入
    [_dataBase executeUpdate:sql, test.testId,test.type, test.date,test.time,test.testTime, test.UvMOS, test.loadTime, test.bandwidth];
    //创建数据库的时候、所设置的数据类型、仅仅是保存到表单中的数据类型
    //我们使用FMDB读写数据库
    //可以不用关心数据库中对应字段的类型、fmdb在操作数据库的时候、会自动把我们传入的对象转化成和表单中定义的字段相同的类型
}

/**
 *  删
 *
 *  @param SVTest
 */
- (void)deleteSVSummaryResultModel:(SVSummaryResultModel *)test
{ //根据testTime 删除记录  where testId = ?
    NSString *sql = @"delete from SVSummaryResultModel;";
    [_dataBase executeUpdate:sql, test.testId];
}


/**
 *  查
 *
 *  @return 所有记录的数组
 */
- (NSArray *)searchAllSVSummaryResultModels
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    // 1、写sql语句
    // select + 字段名 (*表示字段) 如果写*表示取出符合条件的所有字段的值
    // where + 条件   如果where子句不写、表明查询表中所有的记录
    //    NSString *sql = @"select * from RESULT;";
//    static NSString *querySummaryResultSQL =
//    @"select * from SVSummaryResultModel order by %@ desc;";
//    NSString *querySQL = [NSString stringWithFormat:querySummaryResultSQL, @"testTime"];
    // 2、执行sql语句

    FMResultSet *set = [_dataBase executeQuery:@"select * from SVSummaryResultModel;"];

    while ([set next])
    {
        // 取出一条记录中对应字段的值

        SVSummaryResultModel *resultModel = [[SVSummaryResultModel alloc] init];


        resultModel.testId = [set stringForColumn:@"testId"];
       
        resultModel.type = [set stringForColumn:@"type"];
        resultModel.date = [set stringForColumn:@"date"];
        resultModel.time = [set stringForColumn:@"time"];
        
        resultModel.testTime = [set stringForColumn:@"testTime"];
        resultModel.UvMOS = [set stringForColumn:@"UvMOS"];
        resultModel.loadTime = [set stringForColumn:@"loadTime"];
        resultModel.bandwidth = [set stringForColumn:@"bandwidth"];


        [array addObject:resultModel];
    }

    return array;
}


@end
