//
//  ViewController.m
//  BlockDemo
//
//  Created by gdcn on 15-4-8.
//  Copyright (c) 2015年 cndatacom. All rights reserved.
//

#import "ViewController.h"
#import "BlockTest.h"
#import "RetainCountTest.h"
#import "CopyTest.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    [self testGlobalBlock];
//    [self testStackBlock];
//    [self testMallocBlock];
    
    //测试block对变量的访问
//    [self blockTest];
    //测试block操作变量时，变量的retaincount
//    [self retainCountTest];
    //测试对象copy和mutableCopy时retaincount的变化
    [self copyTest];
}


-(void)testGlobalBlock{
    float (^sum)(float, float) = ^(float a, float b){
        
        return a + b;
    };
    
    NSLog(@"%s,block is %@",__func__, sum);//-[ViewController testGlobalBlock],block is <__NSGlobalBlock__: 0x4070>

}
-(void)testStackBlock{
    NSArray *testArr = @[@"1", @"2"];
    
    void (^TestBlock)(void) = ^{
        
        NSLog(@"1testArr :%@",testArr );
    };
    
    NSLog(@"block is %@", ^{
        
        NSLog(@"2test Arr :%@", testArr);
    });
    
    NSLog(@"%s,TestBlock is %@", __func__ ,TestBlock);//-[ViewController testStackBlock],block is <__NSMallocBlock__: 0x8f6b8c0>
}
-(void)testMallocBlock{
    
}

-(void)blockTest{
    BlockTest *test = [[BlockTest alloc]init:10];
    [test AccessVarInBlock];
}

-(void)retainCountTest{
    RetainCountTest *retainCountTest = [[RetainCountTest alloc]init];
    [retainCountTest test];
}


-(void)copyTest{
    CopyTest *test = [[CopyTest alloc]init];
//    [test copyTestWithString];
    [test test];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
