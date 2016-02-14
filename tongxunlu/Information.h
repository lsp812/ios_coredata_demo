//
//  Information.h
//  tongxunlu
//
//  Created by 大麦 on 15/7/15.
//  Copyright (c) 2015年 lsp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Information : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSString * userid;

@end
