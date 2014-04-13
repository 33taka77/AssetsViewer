//
//  CoreDataMngr.m
//  AssetsViewer
//
//  Created by 相澤 隆志 on 2014/04/12.
//  Copyright (c) 2014年 相澤 隆志. All rights reserved.
//

#import "CoreDataMngr.h"
#import <CoreData/CoreData.h>

@interface CoreDataMngr ()
@property (nonatomic, strong) NSString* databaseFileName;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSManagedObjectModel *managedObjectModel;
@property (nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic) NSFetchedResultsController* fetchedResultsController;

@end

@implementation CoreDataMngr


static CoreDataMngr* gCoreDataMngr;

+ (CoreDataMngr*)sharedCoreDataMngr
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gCoreDataMngr = [[CoreDataMngr alloc] init];
    });
    return gCoreDataMngr;
}

- (void)setupCoreDataForFileName:(NSString*)fileName
{
    if( _databaseFileName == nil ){
        _databaseFileName = fileName;
        _managedObjectContext = [self managedObjectContext];
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:_databaseFileName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:_databaseFileName];
    
    BOOL firstRun = ![storeURL checkResourceIsReachableAndReturnError:NULL];
    
    NSError *error;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    /*
	 If this is the first run, populate a new store with events whose timestamps are spaced every 7 days throughout 2013 in the Gregorian calendar.
	 */
	if (firstRun)
    {
	}
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSFetchedResultsController*)fetchedResultsController:(id)target entityName:(NSString*)entityName sectionName:(NSString*)sectionName sort:(NSArray*)sortNames cashe:(NSString*)casheName
{
    if (_fetchedResultsController != nil)
    {
        return _fetchedResultsController;
    }
    
    /*
	 Set up the fetched results controller.
     */
	// Create the fetch request for the entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	// Edit the entity name as appropriate.
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity];
    
	// Set the batch size to a suitable number.
	[fetchRequest setFetchBatchSize:20];
    
	// Sort using the timeStamp property.
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] init];
    for( NSString* sortName in sortNames ){
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortName ascending:YES];
        [sortDescriptors addObject:sortDescriptor];
    }
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Use the sectionIdentifier property to group into sections.
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:sectionName cacheName:casheName];
    _fetchedResultsController.delegate = target;
    
	return _fetchedResultsController;
}

- (NSManagedObject*)addObjectEntityName:(NSString*)name
{
    NSManagedObject* obj = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self.managedObjectContext];
    return obj;
}

- (void)seveData
{
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        // エラーを処理する。 }
        NSLog(@"data save error: %@",error);
        return;
    }
}

- (NSError*)performFetch
{
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    return error;
}
@end
