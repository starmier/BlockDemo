//
//  BlockTest.m
//  BlockDemo
//
//  Created by gdcn on 15-4-8.
//  Copyright (c) 2015年 cndatacom. All rights reserved.
//

#import "BlockTest.h"

@implementation BlockTest{
    int __global_age;
}
@synthesize m_age;

//初始化
- (id) init:(int)age
{
    self = [super init];
    if (nil != self) {
        m_age = age;
    }
    return self;
}

/*可得出以下结论：
 1. 指针变量\类成员变量\静态变量，在Block的内部实现中，是一种引用而非拷贝。
 2. 其他基本类型的变量，在Block的内部实现中，是一种拷贝。
 3. 局部变量在Block内部只读，在block外部修改变量值，也不影响编译时在block中初始化的值。
 
 **
 1）原本的变量i,在block的内部重新定义了一个i并且在该结构体的构造函数进行赋值，也就是对i进行了一份拷贝。
 2）指针变量p ，在block内部也有一个变量p，但是在构造函数的时候，它是指针地址的赋值，也就是说是一份引用。
 **
 */

- (void)AccessVarInBlock
{
    typedef void ( ^ MyBlock )(void);
    
    
    __global_age = 20;                 //全局变量
    int outside_age=20;                //Block 外部的整形变量
    int *p_age = &outside_age;         //Block 外部的指针变量
    static int outside_static_age = 20;//block 外部静态整形变量
    
    
    MyBlock aBlock = ^(){       //start Block
        NSLog(@" class member variable:\tm_global_age = %d", __global_age);
        NSLog(@" class member variable:\tm_age = %d", self.m_age);
        NSLog(@" outside variable: \t\toutside_age = %d", outside_age);
        NSLog(@" outside point variable:p_age = %d", *p_age);
        NSLog(@" outside variable:\toutside_static_age = %d",outside_static_age
              );
        
        __global_age = 200;
        self.m_age = 200; //语句5
        *p_age = 200;     //语句6
//        -------outside_age = 200;//语句7: 一般的外部变量不可修改 Variable is not assignable (missing __block type specifier)
        outside_static_age = 200;//语句8
        
        
        NSLog(@" block modify----class member variable:\tm_global_age = %d", __global_age);
        NSLog(@" block modify----class member variable:\tm_age = %d", self.m_age);
        NSLog(@" block modify----outside variable: \t\toutside_age = %d", outside_age);
        NSLog(@" block modify----outside point variable:p_age = %d", *p_age);
        NSLog(@" block modify----outside variable:\toutside_static_age = %d",outside_static_age
              );
        /*
         2015-04-09 09:51:26.155 BlockDemo[1553:60b]  block modify----class member variable:	m_global_age = 200
         2015-04-09 09:51:26.155 BlockDemo[1553:60b]  block modify----class member variable:	m_age = 200
         2015-04-09 09:51:26.156 BlockDemo[1553:60b]  block modify----outside variable: 		outside_age = 20
         2015-04-09 09:51:26.156 BlockDemo[1553:60b]  block modify----outside point variable:p_age = 200
         2015-04-09 09:51:26.156 BlockDemo[1553:60b]  block modify----outside variable:	outside_static_age = 200

         */
        
    }; //end Block
    
    
    __global_age = 100;
    self.m_age = 100; //语句1
    *p_age = 100;     //语句2
    outside_age = 100;//语句3
    outside_static_age = 100;//语句4
    /*
     2015-04-08 17:48:11.420 BlockDemo[8563:60b]  class member variable:	m_age = 100
     2015-04-08 17:48:11.422 BlockDemo[8563:60b]  outside variable: 		outside_age = 20
     2015-04-08 17:48:11.422 BlockDemo[8563:60b]  outside point variable:p_age = 100
     2015-04-08 17:48:11.423 BlockDemo[8563:60b]  outside variable:	outside_static_age = 100
     */
    
    //如果去掉赋值的三句，结果如下
    /*
     2015-04-09 09:19:05.700 BlockDemo[1088:60b]  class member variable:	m_age = 10
     2015-04-09 09:19:05.701 BlockDemo[1088:60b]  outside variable: 		outside_age = 20
     2015-04-09 09:19:05.702 BlockDemo[1088:60b]  outside point variable:p_age = 20
     2015-04-09 09:19:05.702 BlockDemo[1088:60b]  outside variable:	outside_static_age = 20
     */
    
    aBlock();
    
}
@end
