//
//  CoreDateManager.h
//  tongxunlu
//
//  Created by 大麦 on 15/7/15.
//  Copyright (c) 2015年 lsp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Information.h"



@interface CoreDateManager : NSObject


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

//插入数据
- (void)insertCoreData:(NSMutableArray*)dataArray;
//查询
- (NSMutableArray*)selectData:(int)pageSize andOffset:(int)currentPage;
//删除
-(void)deleteDataWithUserId:(NSString *)userid;
//更新
- (void)updateData:(NSString*)userId  withIsSex:(NSString*)sex;
//获取所有
- (NSMutableArray *)dataFetchAllRequest;

@end
