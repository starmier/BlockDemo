//
//  BlockTest.h
//  BlockDemo
//
//  Created by gdcn on 15-4-8.
//  Copyright (c) 2015年 cndatacom. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 block 对变量的访问：成员变量，property，局部变量，局部静态变量
 */
@interface BlockTest : NSObject

@property (nonatomic) int m_age;


//初始化
- (id) init:(int)age;

- (void)AccessVarInBlock;

@end
