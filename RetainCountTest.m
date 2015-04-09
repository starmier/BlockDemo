//
//  RetainCountTest.m
//  BlockDemo
//
//  Created by gdcn on 15-4-9.
//  Copyright (c) 2015年 cndatacom. All rights reserved.
//

#import "RetainCountTest.h"

/*
 *
 注意区分对象地址和指向对象的指针地址
 *
 *
 1.全局变量(__globalObj) 和 局部静态变量(__staticObj)在内存中的位置是确定的，所以Block copy时不会retain对象。
 2.成员变量(_instanceObj)在Block copy时也没有直接retain, _instanceObj对象本身，但会retain self。所以在Block中可以直接读写_instanceObj变量。
 3.局部变量(localObj)在Block copy时，block会复制指针，且强引用指针指向的对象一次(系统自动retain对象)，增加其引用计数。
 4.block变量(__block修饰的变量，blockObj，基本类型的Block变量等效于全局变量、或静态变量)在Block copy时也不会retain。
 5.即时标记了为__weak或__unsafe_unretained的local变量。block仍会强引用指针对象一次
 *
 *
 6.因此，对于block的循环引用问题，因为block在拷贝到堆上的时候，会retain其引用的外部变量，那么如果block中如果引用了他的宿主对象(self)，那很有可能引起循环引用
 
 */

@implementation RetainCountTest{
    NSObject* _instanceObj;
}

NSObject* __globalObj = nil;

- (id) init {
    if (self = [super init]) {
        _instanceObj = [[NSObject alloc] init];
    }
    return self;
}

- (void) test1 {
    
    NSObject *obj = [[NSObject alloc]init];
    
    static NSObject* __staticObj = nil;
    __globalObj =obj;
    __staticObj = obj;
    
    NSObject* localObj = obj;
    __block NSObject* blockObj =  obj;
    __weak NSObject* weakObj = obj;
    
    typedef void (^MyBlock)(void) ;
    MyBlock aBlock = ^{
        NSLog(@"%@,%p,%p", __globalObj,&__globalObj,obj);
        NSLog(@"%@,%p,%p", __staticObj,&__staticObj,obj);
        NSLog(@"%@,%p,%p", _instanceObj,&_instanceObj,obj);
        NSLog(@"%@,%p,%p", localObj,&localObj,obj);//-----局部变量在block的内部只读，局部变量的内存地址发生了变化，拷贝了指针，并且强引用指针指向的对象一次（retain一次），多一块内存指向数据
        NSLog(@"%@,%p,%p", blockObj,&blockObj,obj);
        NSLog(@"%@,%p,%p", weakObj,&weakObj,obj);//-----
        /*
         2015-04-09 11:55:16.337 BlockDemo[3206:60b] <NSObject: 0x8d4c440>,0x5a64
         2015-04-09 11:55:16.338 BlockDemo[3206:60b] <NSObject: 0x8d4c450>,0x5a50
         2015-04-09 11:55:16.339 BlockDemo[3206:60b] <NSObject: 0x8d4aec0>,0x8d4aeb4
         2015-04-09 11:55:16.339 BlockDemo[3206:60b] <NSObject: 0x8d4bf70>,0x8d4ad98
         2015-04-09 11:55:16.339 BlockDemo[3206:60b] <NSObject: 0x8d4bf80>,0x8d4ab38
         2015-04-09 11:55:16.340 BlockDemo[3206:60b] <NSObject: 0x8d4b0e0>,0x8d4ad9c

         */
    };
    
    aBlock = [[aBlock copy] autorelease];
    
    aBlock();
    
    NSLog(@"%d,%p", [__globalObj retainCount],&__globalObj);//全局变量 1,0x5a64
    NSLog(@"%d,%p", [__staticObj retainCount],&__staticObj);//局部静态变量 1,0x5a50
    NSLog(@"%d,%p", [_instanceObj retainCount],&_instanceObj);//成员变量 1,0x8d4aeb4
    NSLog(@"%d,%p", [localObj retainCount],&localObj);//局部变量 2,0xbfffc934
    NSLog(@"%d,%p", [blockObj retainCount],&blockObj);//block变量 1,0x8d4ab38
    NSLog(@"%d,%p", [weakObj retainCount],&weakObj);//weak变量 2,0xbfffc914
    /*
     2015-04-09 11:55:16.340 BlockDemo[3206:60b] 1,0x5a64
     2015-04-09 11:55:16.341 BlockDemo[3206:60b] 1,0x5a50
     2015-04-09 11:55:16.341 BlockDemo[3206:60b] 1,0x8d4aeb4
     2015-04-09 11:55:16.342 BlockDemo[3206:60b] 2,0xbfffc934
     2015-04-09 11:55:16.342 BlockDemo[3206:60b] 1,0x8d4ab38
     2015-04-09 11:55:16.343 BlockDemo[3206:60b] 2,0xbfffc914
     */
}
- (void) test {
    
    
    static NSObject* __staticObj = nil;
    __globalObj = [[NSObject alloc] init];
    __staticObj = [[NSObject alloc] init];
    
    NSObject* localObj = [[NSObject alloc] init];

    __block NSObject* blockObj = [[NSObject alloc] init];

    __weak NSObject* weakObj = [[NSObject alloc] init];
  
    
    typedef void (^MyBlock)(void) ;
    MyBlock aBlock = ^{
        NSLog(@"%@,%p", __globalObj,&__globalObj);
        NSLog(@"%@,%p", __staticObj,&__staticObj);
        NSLog(@"%@,%p", _instanceObj,&_instanceObj);
        NSLog(@"%@,%p", localObj,&localObj);//-----局部变量在block的内部只读，局部变量的内存地址发生了变化，拷贝了指针，并且强引用指针指向的对象一次（retain一次），多一块内存指向数据
        NSLog(@"%@,%p", blockObj,&blockObj);
        NSLog(@"%@,%p", weakObj,&weakObj);//-----
        /*
         2015-04-09 11:55:16.337 BlockDemo[3206:60b] <NSObject: 0x8d4c440>,0x5a64
         2015-04-09 11:55:16.338 BlockDemo[3206:60b] <NSObject: 0x8d4c450>,0x5a50
         2015-04-09 11:55:16.339 BlockDemo[3206:60b] <NSObject: 0x8d4aec0>,0x8d4aeb4
         2015-04-09 11:55:16.339 BlockDemo[3206:60b] <NSObject: 0x8d4bf70>,0x8d4ad98
         2015-04-09 11:55:16.339 BlockDemo[3206:60b] <NSObject: 0x8d4bf80>,0x8d4ab38
         2015-04-09 11:55:16.340 BlockDemo[3206:60b] <NSObject: 0x8d4b0e0>,0x8d4ad9c
         
         */
    };
    
    aBlock = [[aBlock copy] autorelease];
    
    aBlock();
    
    NSLog(@"%d,%p", [__globalObj retainCount],&__globalObj);//全局变量 1,0x5a64
    NSLog(@"%d,%p", [__staticObj retainCount],&__staticObj);//局部静态变量 1,0x5a50
    NSLog(@"%d,%p", [_instanceObj retainCount],&_instanceObj);//成员变量 1,0x8d4aeb4
    NSLog(@"%d,%p", [localObj retainCount],&localObj);//局部变量 2,0xbfffc934
    NSLog(@"%d,%p", [blockObj retainCount],&blockObj);//block变量 1,0x8d4ab38
    NSLog(@"%d,%p", [weakObj retainCount],&weakObj);//weak变量 2,0xbfffc914
    /*
     2015-04-09 11:55:16.340 BlockDemo[3206:60b] 1,0x5a64
     2015-04-09 11:55:16.341 BlockDemo[3206:60b] 1,0x5a50
     2015-04-09 11:55:16.341 BlockDemo[3206:60b] 1,0x8d4aeb4
     2015-04-09 11:55:16.342 BlockDemo[3206:60b] 2,0xbfffc934
     2015-04-09 11:55:16.342 BlockDemo[3206:60b] 1,0x8d4ab38
     2015-04-09 11:55:16.343 BlockDemo[3206:60b] 2,0xbfffc914
     */
}

- (void)dealloc
{
    [super dealloc];
    NSLog(@"no cycle retain");
}

- (id)initCycleTest
{
    self = [super init];
    if (self) {
        
#if TestCycleRetainCase1
        
        //会循环引用
        self.myblock = ^{
            
            [self doSomething];
        };
#elif TestCycleRetainCase2
        
        //会循环引用
        __block TestCycleRetain *weakSelf = self;
        self.myblock = ^{
            
            [weakSelf doSomething];
        };
        
#elif TestCycleRetainCase3
        
        //不会循环引用
        __weak TestCycleRetain *weakSelf = self;
        self.myblock = ^{
            
            [weakSelf doSomething];
        };
        
#elif TestCycleRetainCase4
        
        //不会循环引用
        __unsafe_unretained TestCycleRetain *weakSelf = self;
        self.myblock = ^{
            
            [weakSelf doSomething];
        };
        
#endif
  
    }
    return self;
}

- (void)doSomething
{
    NSLog(@"do Something");
}

@end
