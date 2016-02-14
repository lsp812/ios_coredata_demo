//
//  CoreDateManager.m
//  tongxunlu
//
//  Created by 大麦 on 15/7/15.
//  Copyright (c) 2015年 lsp. All rights reserved.
//

#import "CoreDateManager.h"
#include "InfoT.h"
@implementation CoreDateManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
}


#pragma mark - Core Data stack
// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    //.xcdatamodeld名称
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"tongxunlu" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"AddressBook.data"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return _persistentStoreCoordinator;
}


#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.获取Documents路径
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

//插入数据
- (void)insertCoreData:(NSMutableArray*)dataArray
{
    NSLog(@"插入");
    NSLog(@"dataArray = %@",dataArray);
    NSManagedObjectContext *context = [self managedObjectContext];
    for(InfoT *info in dataArray)
    {
        Information *newInfo = (Information *)[NSEntityDescription insertNewObjectForEntityForName:INFORMATION inManagedObjectContext:context];
        newInfo.name = info.name;
        newInfo.sex = info.sex;
        newInfo.userid = info.userid;
    }
    NSError *error;
    
    if(![context save:&error])
    {
        NSLog(@"不能保存：%@",[error localizedDescription]);
    }
    else
    {
        NSLog(@"插入成功");
    }
    NSLog(@"context=%@",context);
    
}
//查询
- (NSMutableArray*)selectData:(int)pageSize andOffset:(int)currentPage
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // 限定查询结果的数量
    //setFetchLimit
    // 查询的偏移量
    //setFetchOffset
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    [fetchRequest setFetchLimit:pageSize];
    [fetchRequest setFetchOffset:currentPage];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:INFORMATION inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *resultArray = [NSMutableArray array];
    
    NSLog(@"fetchedObjects=%lu",(unsigned long)[fetchedObjects count]);
    
    for (Information *info in fetchedObjects) {
        //        NSLog(@"name:%@", info.name);
        //        NSLog(@"sex:%@", info.sex);
        //        NSLog(@"userid:%@", info.userid);
        [resultArray addObject:info];
    }
    return resultArray;
}

//删除
-(void)deleteDataWithUserId:(NSString *)userid
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:INFORMATION inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:entity];
    if(userid!=nil && userid.length!=0)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userid = %@",userid];
        [request setPredicate:predicate];
    }
    
    NSError *error = nil;
    
    NSArray *datas = [context executeFetchRequest:request error:&error];
    
    [context setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];//重要!!!
    
    if (!error && datas && [datas count])
    {
        for (NSManagedObject *obj in datas)
        {
            NSLog(@"del");
            [context deleteObject:obj];
        }
        if (![context save:&error])
        {
            NSLog(@"error:%@",error);
        }
        else
        {
            NSLog(@"删除成功");
        }
    }
}
//更新
- (void)updateData:(NSString*)userId  withIsSex:(NSString*)sex
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"userid = %@",userId];
    
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:INFORMATION inManagedObjectContext:context]];
    [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
    
    //https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/Predicates/Articles/pCreating.html
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];//这里获取到的是一个数组，你需要取出你要更新的那个obj
    for (Information *info in result) {
        info.sex = sex;
        if([sex isEqualToString:@"boy"])
        {
            info.sex = @"girl";
        }
        else
        {
            info.sex = @"boy";
        }
    }
    
    //保存
    if ([context save:&error]) {
        //更新成功
        NSLog(@"更新成功");
    }
}

//获取所有
- (NSMutableArray *)dataFetchAllRequest
{
//    NSManagedObjectContext *context = [self managedObjectContext];
//    
//    // 限定查询结果的数量
//    //setFetchLimit
//    // 查询的偏移量
//    //setFetchOffset
//    
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    
//    
//    NSEntityDescription *entity = [NSEntityDescription entityForName:INFORMATION inManagedObjectContext:context];
//    [fetchRequest setEntity:entity];
//    
//    
//    NSError *error;
//    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
//    NSMutableArray *resultArray = [NSMutableArray array];
//    
//    NSLog(@"fetchedObjects=%d",[fetchedObjects count]);
//    
//    for (Information *info in fetchedObjects) {
//        [resultArray addObject:info];
//    }
//    return resultArray;
    return nil;
    
}

-(void)addQueue//为数据库添加队列
{
//    NSOperationQueue[];
    
}


@end
