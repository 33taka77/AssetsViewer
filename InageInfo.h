//
//  InageInfo.h
//  AssetsViewer
//
//  Created by 相澤 隆志 on 2014/04/12.
//  Copyright (c) 2014年 相澤 隆志. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface InageInfo : NSManagedObject

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSDate * dateTime;
@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) NSString * maker;
@property (nonatomic, retain) NSString * exposerTime;
@property (nonatomic, retain) NSString * forcalLength;
@property (nonatomic, retain) NSNumber * orientation;
@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSString * fNumber;
@property (nonatomic, retain) NSString * iso;
@property (nonatomic, retain) NSString * maxApertureValue;
@property (nonatomic, retain) NSString * exposureCompensation;
@property (nonatomic, retain) NSString * flash;
@property (nonatomic, retain) NSString * lensInfo;
@property (nonatomic, retain) NSString * lensModel;
@property (nonatomic, retain) NSString * lens;
@property (nonatomic, retain) id thunbnail;
@property (nonatomic, retain) id aspectThumbnail;
@property (nonatomic, retain) NSString * sectionIdentifire;
@property (nonatomic, retain) NSString * groupUrl;

@end
