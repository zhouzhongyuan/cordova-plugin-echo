//
//  Sigleton.h
//  离线app
//
//  Created by 王吉源 on 16/10/14.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomerModel.h"
#import "RetreatReasonModel.h"
#import <UIKit/UIKit.h>
@interface Sigleton : NSObject
+(instancetype)standard;
@property(nonatomic,strong)CustomerModel *customerModel;
@property(nonatomic,strong)RetreatReasonModel *retreatReasonModel;
@property(nonatomic,strong)UIImage *image1;
@property(nonatomic,strong)UIImage *image2;
@property(nonatomic,strong)UIImage *image3;
@property(nonatomic,strong)UIImage *image4;
@end
