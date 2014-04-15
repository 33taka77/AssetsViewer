//
//  InageInfo.m
//  AssetsViewer
//
//  Created by 相澤 隆志 on 2014/04/12.
//  Copyright (c) 2014年 相澤 隆志. All rights reserved.
//

#import "InageInfo.h"

@interface InageInfo ()

@property (nonatomic) NSDate *primitiveTimeStamp;
@property (nonatomic) NSString *primitiveSectionIdentifier;

@end


@implementation InageInfo

@dynamic url;
@dynamic dateTime;
@dynamic model;
@dynamic maker;
@dynamic exposerTime;
@dynamic forcalLength;
@dynamic orientation;
@dynamic artist;
@dynamic fNumber;
@dynamic iso;
@dynamic maxApertureValue;
@dynamic exposureCompensation;
@dynamic flash;
@dynamic lensInfo;
@dynamic lensModel;
@dynamic lens;
@dynamic thunbnail;
@dynamic aspectThumbnail;
@dynamic sectionIdentifire;
@dynamic groupUrl;

@dynamic primitiveTimeStamp;
@dynamic primitiveSectionIdentifier;

/*
- (NSString *)sectionIdentifier
{
    // Create and cache the section identifier on demand.
    
    [self willAccessValueForKey:@"sectionIdentifier"];
    NSString *tmp = [self primitiveSectionIdentifier];
    [self didAccessValueForKey:@"sectionIdentifier"];
    
    if (!tmp)
    {
        
        // Sections are organized by month and year. Create the section identifier as a string representing //the number (year * 1000) + month; this way they will be correctly ordered //chronologically regardless of the actual name of the month.
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:[self dateTime]];
        tmp = [NSString stringWithFormat:@"%d", ([components year] * 1000) + [components month]];
        [self setPrimitiveSectionIdentifier:tmp];
    }
    return tmp;
}


- (void)setDateTime:(NSDate *)newDate
{
    // If the time stamp changes, the section identifier become invalid.
    [self willChangeValueForKey:@"dateTime"];
    [self setPrimitiveTimeStamp:newDate];
    [self didChangeValueForKey:@"dateTime"];
    
    [self setPrimitiveSectionIdentifier:nil];
}


+ (NSSet *)keyPathsForValuesAffectingSectionIdentifier
{
    // If the value of timeStamp changes, the section identifier may change as well.
    return [NSSet setWithObject:@"dateTime"];
}
*/

@end
