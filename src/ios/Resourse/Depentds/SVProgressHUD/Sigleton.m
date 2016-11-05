//
//  Sigleton.m
//  离线app
//
//  Created by 王吉源 on 16/10/14.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "Sigleton.h"

@implementation Sigleton
+(instancetype)standard{
    static Sigleton *sigleton = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sigleton = [[self alloc] init];
    });
    return sigleton;
}
@end
