//
//  CoreDataMngr.h
//  AssetsViewer
//
//  Created by 相澤 隆志 on 2014/04/12.
//  Copyright (c) 2014年 相澤 隆志. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataMngr : NSObject
+ (CoreDataMngr*)sharedCoreDataMngr;
- (void)setupCoreDataForFileName:(NSString*)fileName;
- (NSManagedObject*)addObjectEntityName:(NSString*)name;
- (NSFetchedResultsController*)fetchedResultsController:(id)target entityName:(NSString*)entityName sectionName:(NSString*)sectionName sort:(NSArray*)sortNames cashe:(NSString*)casheName;
- (void)seveData;
- (NSError*)performFetch;
@end
