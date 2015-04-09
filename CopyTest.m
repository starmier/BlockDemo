//
//  CopyTest.m
//  BlockDemo
//
//  Created by gdcn on 15-4-9.
//  Copyright (c) 2015年 cndatacom. All rights reserved.
//

#import "CopyTest.h"

@implementation CopyTest

/*
 注意并不是所有的对象都可以进行copy 和 mutablecopy， 只有实现对应的协议才可以向对象发送对应的消息，否则会发生异常
 */
-(void)copyTestWithString{
    
//    NSString *string = @"origion";
    /* 可理解为静态变量，内存中的位置是确定的，并且内存有系统负责回收
     stringP = 0xbfffc930,string= 0x69b8,string= origion,retaincount = -1
     stringCopyP = 0xbfffc92c,stringCopy = 0x69b8,stringCopy = origion,retaincount = -1
     stringMCopyP = 0xbfffc928,stringMCopy = 0x8c19920,stringMCopy = origion!!,retaincount = 1
     */
    
    
    NSString *string = [[NSString alloc]initWithFormat:@"%@",@"origion"];
    /* 手动 alloc 创建的变量，内存由用户手动回收
     stringP = 0xbfffc930,string= 0x8c3ed90,string= origion,retaincount = 2
     stringCopyP = 0xbfffc92c,stringCopy = 0x8c3ed90,stringCopy = origion,retaincount = 2
     stringMCopyP = 0xbfffc928,stringMCopy = 0x8c474a0,stringMCopy = origion!!,retaincount = 1
     mStringCopyP = 0xbfffc924,mStringCopy = 0x8d66700,mStringCopy = origion!!,retaincount = 1
     */
    NSString *stringCopy = [string copy];
    NSMutableString *stringMCopy = [string mutableCopy];
    [stringMCopy appendString:@"!!"];
    NSString *mStringCopy = [stringMCopy copy];
//    [mStringCopy appendString:@"!!"];//Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: 'Attempt to mutate immutable object with appendString:'
    
    /*
     如果对一不可变对象复制，copy是指针复制（浅拷贝）和mutableCopy就是对象复制（深拷贝）。如果是对可变对象复制，都是深拷贝，但是copy返回的对象是不可变的
     */
    
    NSLog(@"stringP = %p,string= %p,string= %@,retaincount = %d\nstringCopyP = %p,stringCopy = %p,stringCopy = %@,retaincount = %d\nstringMCopyP = %p,stringMCopy = %p,stringMCopy = %@,retaincount = %d\nmStringCopyP = %p,mStringCopy = %p,mStringCopy = %@,retaincount = %d",&string,string,string,[string retainCount],&stringCopy,stringCopy,stringCopy,[stringCopy retainCount],&stringMCopy,stringMCopy,stringMCopy,[stringMCopy retainCount],&mStringCopy,mStringCopy,mStringCopy,[mStringCopy retainCount]);
    
    /*
     可见对于NSString，copy操作后的对象(stringCopy)和原来的对象(string)指向的是同一块内存(0x69b8),此时又称为弱引用(weak reference),而此时两个对象的retaincount都为2
     而mutableCopy 则是分配了新的内存来存储内容，并且指针也复制了
     */
}

-(void)test{
//    NSString *string = @"origion";//此时所有的retaincount都为-1，retain和release操作都没有效用
//    NSString *string = [NSString stringWithFormat:@"%@",@"origion"];
    NSString *string = [[NSString alloc]initWithFormat:@"%@",@"origion"];
    NSLog(@"stringP = %p,stringContentP=%p,retainCount = %d",&string,string,[string retainCount]);
    NSString *retainString = [string retain];
    NSLog(@"1retain--stringP = %p,stringContentP=%p,retainCount = %d",&string,string,[string retainCount]);
    NSLog(@"1retain--retainStringP = %p,retainStringContentP=%p,retainCount = %d",&retainString,retainString,[retainString retainCount]);
    
    NSString *retainString2 = [retainString retain];
    NSLog(@"2retain--stringP = %p,stringContentP=%p,retainCount = %d",&string,string,[string retainCount]);
    NSLog(@"2retain--retainStringP = %p,retainStringContentP=%p,retainCount = %d",&retainString,retainString,[retainString retainCount]);
    NSLog(@"2retain--retainString2P = %p,retainString2ContentP=%p,retainCount = %d",&retainString2,retainString2,[retainString2 retainCount]);
    
    
    [retainString2 release];
    
    NSLog(@"3release--stringP = %p,stringContentP=%p,retainCount = %d",&string,string,[string retainCount]);
    NSLog(@"3release--retainStringP = %p,retainStringContentP=%p,retainCount = %d",&retainString,retainString,[retainString retainCount]);
    NSLog(@"3release--retainString2P = %p,retainString2ContentP=%p,retainCount = %d",&retainString2,retainString2,[retainString2 retainCount]);
    
    NSString *retainString3 = [retainString copy];//浅拷贝或者是弱引用，这里只拷贝指针，拷贝后指针和之前的指向的是同一块内存，自然输出的内容也一致
    NSLog(@"4copy--stringP = %p,stringContentP=%p,retainCount = %d",&string,string,[string retainCount]);
    NSLog(@"4copy--retainStringP = %p,retainStringContentP=%p,retainCount = %d",&retainString,retainString,[retainString retainCount]);
    NSLog(@"4copy--retainString2P = %p,retainString2ContentP=%p,retainCount = %d",&retainString2,retainString2,[retainString2 retainCount]);
    NSLog(@"4copy--retainString3P = %p,retainString3ContentP=%p,retainCount = %d",&retainString3,retainString3,[retainString3 retainCount]);
    
    [retainString3 release];
    
    NSLog(@"5release--stringP = %p,stringContentP=%p,retainCount = %d",&string,string,[string retainCount]);
    NSLog(@"5release--retainStringP = %p,retainStringContentP=%p,retainCount = %d",&retainString,retainString,[retainString retainCount]);
    NSLog(@"5release--retainString2P = %p,retainString2ContentP=%p,retainCount = %d",&retainString2,retainString2,[retainString2 retainCount]);
    NSLog(@"5release--retainString3P = %p,retainString3ContentP=%p,retainCount = %d",&retainString3,retainString3,[retainString3 retainCount]);
    
    NSString *retainString4 = [retainString mutableCopy];//深copy会产生新的对象，指针和存放内容的地址都拷贝了一份儿新的，原来的对象的retaincount不变，新对象的retaincount为1
    NSLog(@"6mutableCopy--stringP = %p,stringContentP=%p,retainCount = %d",&string,string,[string retainCount]);
    NSLog(@"6mutableCopy--retainStringP = %p,retainStringContentP=%p,retainCount = %d",&retainString,retainString,[retainString retainCount]);
    NSLog(@"6mutableCopy--retainString2P = %p,retainString2ContentP=%p,retainCount = %d",&retainString2,retainString2,[retainString2 retainCount]);
    NSLog(@"6mutableCopy--retainString3P = %p,retainString3ContentP=%p,retainCount = %d",&retainString3,retainString3,[retainString3 retainCount]);
    NSLog(@"6mutableCopy--retainString4P = %p,retainString4ContentP=%p,retainCount = %d",&retainString4,retainString4,[retainString4 retainCount]);
    
    [retainString4 release];
    
    NSLog(@"7release--stringP = %p,stringContentP=%p,retainCount = %d",&string,string,[string retainCount]);
    NSLog(@"7release--retainStringP = %p,retainStringContentP=%p,retainCount = %d",&retainString,retainString,[retainString retainCount]);
    NSLog(@"7release--retainString2P = %p,retainString2ContentP=%p,retainCount = %d",&retainString2,retainString2,[retainString2 retainCount]);
    NSLog(@"7release--retainString3P = %p,retainString3ContentP=%p,retainCount = %d",&retainString3,retainString3,[retainString3 retainCount]);
//    NSLog(@"7mutableCopy--retainString4P = %p,retainString4ContentP=%p,retainCount = %d",&retainString4,retainString4,[retainString4 retainCount]);//此时对象已经不存在，release 会导致访问野指针，造成crash
    
    /*
     2015-04-09 15:06:04.914 BlockDemo[5621:60b] stringP = 0xbfffc930,stringContentP=0x8e6e920,retainCount = 1
     2015-04-09 15:06:04.915 BlockDemo[5621:60b] 1retain--stringP = 0xbfffc930,stringContentP=0x8e6e920,retainCount = 2
     2015-04-09 15:06:04.916 BlockDemo[5621:60b] 1retain--retainStringP = 0xbfffc92c,retainStringContentP=0x8e6e920,retainCount = 2
     2015-04-09 15:06:04.916 BlockDemo[5621:60b] 2retain--stringP = 0xbfffc930,stringContentP=0x8e6e920,retainCount = 3
     2015-04-09 15:06:04.917 BlockDemo[5621:60b] 2retain--retainStringP = 0xbfffc92c,retainStringContentP=0x8e6e920,retainCount = 3
     2015-04-09 15:06:04.917 BlockDemo[5621:60b] 2retain--retainString2P = 0xbfffc928,retainString2ContentP=0x8e6e920,retainCount = 3
     2015-04-09 15:06:04.918 BlockDemo[5621:60b] 3release--stringP = 0xbfffc930,stringContentP=0x8e6e920,retainCount = 2
     2015-04-09 15:06:04.918 BlockDemo[5621:60b] 3release--retainStringP = 0xbfffc92c,retainStringContentP=0x8e6e920,retainCount = 2
     2015-04-09 15:06:04.918 BlockDemo[5621:60b] 3release--retainString2P = 0xbfffc928,retainString2ContentP=0x8e6e920,retainCount = 2
     2015-04-09 15:06:04.919 BlockDemo[5621:60b] 4copy--stringP = 0xbfffc930,stringContentP=0x8e6e920,retainCount = 3
     2015-04-09 15:06:04.919 BlockDemo[5621:60b] 4copy--retainStringP = 0xbfffc92c,retainStringContentP=0x8e6e920,retainCount = 3
     2015-04-09 15:06:04.920 BlockDemo[5621:60b] 4copy--retainString2P = 0xbfffc928,retainString2ContentP=0x8e6e920,retainCount = 3
     2015-04-09 15:06:04.921 BlockDemo[5621:60b] 4copy--retainString3P = 0xbfffc924,retainString3ContentP=0x8e6e920,retainCount = 3
     2015-04-09 15:06:04.921 BlockDemo[5621:60b] 5release--stringP = 0xbfffc930,stringContentP=0x8e6e920,retainCount = 2
     2015-04-09 15:06:04.922 BlockDemo[5621:60b] 5release--retainStringP = 0xbfffc92c,retainStringContentP=0x8e6e920,retainCount = 2
     2015-04-09 15:06:04.922 BlockDemo[5621:60b] 5release--retainString2P = 0xbfffc928,retainString2ContentP=0x8e6e920,retainCount = 2
     2015-04-09 15:06:04.923 BlockDemo[5621:60b] 5release--retainString3P = 0xbfffc924,retainString3ContentP=0x8e6e920,retainCount = 2
     2015-04-09 15:06:04.923 BlockDemo[5621:60b] 6mutableCopy--stringP = 0xbfffc930,stringContentP=0x8e6e920,retainCount = 2
     2015-04-09 15:06:04.924 BlockDemo[5621:60b] 6mutableCopy--retainStringP = 0xbfffc92c,retainStringContentP=0x8e6e920,retainCount = 2
     2015-04-09 15:06:04.924 BlockDemo[5621:60b] 6mutableCopy--retainString2P = 0xbfffc928,retainString2ContentP=0x8e6e920,retainCount = 2
     2015-04-09 15:06:04.924 BlockDemo[5621:60b] 6mutableCopy--retainString3P = 0xbfffc924,retainString3ContentP=0x8e6e920,retainCount = 2
     2015-04-09 15:06:04.925 BlockDemo[5621:60b] 6mutableCopy--retainString4P = 0xbfffc920,retainString4ContentP=0x8e6f930,retainCount = 1
     2015-04-09 15:06:04.925 BlockDemo[5621:60b] 7release--stringP = 0xbfffc930,stringContentP=0x8e6e920,retainCount = 2
     2015-04-09 15:06:04.926 BlockDemo[5621:60b] 7release--retainStringP = 0xbfffc92c,retainStringContentP=0x8e6e920,retainCount = 2
     2015-04-09 15:06:04.926 BlockDemo[5621:60b] 7release--retainString2P = 0xbfffc928,retainString2ContentP=0x8e6e920,retainCount = 2
     2015-04-09 15:06:04.926 BlockDemo[5621:60b] 7release--retainString3P = 0xbfffc924,retainString3ContentP=0x8e6e920,retainCount = 2
     (lldb)
     */
}

@end
