//
//  RootViewController.m
//  AssetsViewer
//
//  Created by 相澤 隆志 on 2014/04/12.
//  Copyright (c) 2014年 相澤 隆志. All rights reserved.
//

#import "RootViewController.h"
#import "AssetManager.h"
#import "CoreDataMngr.h"
#import "InageInfo.h"
#import "ImageTableViewCell.h"

@interface RootViewController () <AssetLibraryDelegate>
@property (nonatomic, strong) AssetManager* assetsMngr;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSMutableArray* arrayOfAssets;
@end

@implementation RootViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)updateGroupDataGroupURL:(NSURL *)groupUrl
{
    //[self performSelectorOnMainThread:@selector(refresh:)
    //                       withObject:groupUrl
    //                    waitUntilDone:NO];
    //[self.tableView reloadData];
    [self refresh:groupUrl];
}
- (void)refresh:(id)obj
{
    NSURL* group = (NSURL*)obj;

    for( NSDictionary* dict in _assetsMngr.arrayOfAssetsInfo ){
        NSURL* groupUrl = [dict valueForKey:@"groupUrl"];
        if(group == [dict valueForKey:@"groupUrl"]){
            
            NSURL* url = [dict valueForKey:@"url"];
            //NSDictionary* metaData = [_assetsMngr getMetaDataByURL:url];
            //UIImage* thumbnail = [dict valueForKey:@"thumbnail"];
            //UIImage* aspectThumbnail = [dict valueForKey:@"aspectThumbnail"];;
            CoreDataMngr* coreDataMngr = [CoreDataMngr sharedCoreDataMngr];
            InageInfo* imageInfo = (InageInfo*)[coreDataMngr addObjectEntityName:@"InageInfo"];
            //imageInfo.thunbnail = thumbnail;
            //imageInfo.aspectThumbnail = aspectThumbnail;
            imageInfo.url = [url absoluteString];
            imageInfo.groupUrl = [groupUrl absoluteString];
            imageInfo.model = [dict valueForKey:@"Model"];
            imageInfo.maker = [dict valueForKey:@"Maker"];
            imageInfo.exposerTime = [dict valueForKey:@"ExposureTime"];
            imageInfo.forcalLength = [dict valueForKey:@"FocalLength"];
            imageInfo.orientation = [self cnvertNumber: [dict valueForKey:@"Orientation"]];
            imageInfo.artist = [dict valueForKey:@"Artist"];
            imageInfo.fNumber = [dict valueForKey:@"FNumber"];
            imageInfo.iso = [dict valueForKey:@"ISO"];
            imageInfo.maxApertureValue = [dict valueForKey:@"MaxApertureValue"];
            imageInfo.exposureCompensation = [dict valueForKey:@"ExposureCompensation"];
            imageInfo.flash = [dict valueForKey:@"Flash"];
            imageInfo.lensInfo = [dict valueForKey:@"LensInfo"];
            imageInfo.lensModel = [dict valueForKey:@"LensModel"];
            imageInfo.lens = [dict valueForKey:@"Lens"];
            imageInfo.dateTime = [self dateTime:[dict valueForKey:@"DateTimeOriginal"]];
            imageInfo.sectionIdentifire = [self dateTimeString:imageInfo.dateTime];
            [coreDataMngr seveData];
        }
    }
    
}

- (void)updateItemDataItemURL:(NSURL *)url groupURL:(NSURL *)groupUrl
{
    NSDictionary* assetInfo = @{@"assetUrl":url, @"groupUrl":groupUrl};
    [_arrayOfAssets addObject:assetInfo];

    /*
    NSDictionary* metaData = [_assetsMngr getMetaDataByURL:url];
    UIImage* thumbnail = [_assetsMngr getThumbnail:url];
    UIImage* aspectThumbnail = [_assetsMngr getThumbnailAspect:url];
    CoreDataMngr* coreDataMngr = [CoreDataMngr sharedCoreDataMngr];
    InageInfo* imageInfo = (InageInfo*)[coreDataMngr addObjectEntityName:@""];
    imageInfo.thunbnail = thumbnail;
    imageInfo.aspectThumbnail = aspectThumbnail;
    imageInfo.url = [url absoluteString];
    imageInfo.groupUrl = [groupUrl absoluteString];
    imageInfo.model = [metaData valueForKey:@"Model"];
    imageInfo.maker = [metaData valueForKey:@"Maker"];
    imageInfo.exposerTime = [metaData valueForKey:@"ExposureTime"];
    imageInfo.forcalLength = [metaData valueForKey:@"FocalLength"];
    imageInfo.orientation = [self cnvertNumber: [metaData valueForKey:@"Orientation"]];
    imageInfo.artist = [metaData valueForKey:@"Artist"];
    imageInfo.fNumber = [metaData valueForKey:@"FNumber"];
    imageInfo.iso = [metaData valueForKey:@"ISO"];
    imageInfo.maxApertureValue = [metaData valueForKey:@"MaxApertureValue"];
    imageInfo.exposureCompensation = [metaData valueForKey:@"ExposureCompensation"];
    imageInfo.flash = [metaData valueForKey:@"Flash"];
    imageInfo.lensInfo = [metaData valueForKey:@"LensInfo"];
    imageInfo.lensModel = [metaData valueForKey:@"LensModel"];
    imageInfo.lens = [metaData valueForKey:@"Lens"];
    imageInfo.dateTime = [self dateTime:[metaData valueForKey:@"DateTimeOriginal"]];
    imageInfo.sectionIdentifire = imageInfo.groupUrl;
    [coreDataMngr seveData];
    */
}

- (NSString*)dateTimeString:(NSDate*)dateTime
{
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
    [inputDateFormatter setDateFormat:@"yyyy/MM/dd"];
    return [inputDateFormatter stringFromDate:dateTime];
   
}

- (NSDate*)dateTime:(NSString*)dateTime
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy:MM:dd HH:MM:SS"];
    NSDate *formatterDate = [inputFormatter dateFromString:dateTime];
    return formatterDate;
}

- (NSNumber*)cnvertNumber:(NSString*)number
{
    int num = [number intValue];
    return [NSNumber numberWithInt:num];
}

- (void)deleteImage
{
    NSError* error;
    _fetchedResultsController.delegate = nil;               // turn off delegate callbacks
    for (InageInfo *message in [_fetchedResultsController fetchedObjects]) {
        [_fetchedResultsController.managedObjectContext deleteObject:message];
    }
    if (![_fetchedResultsController.managedObjectContext save:&error]) {
        // TODO: Handle the error appropriately.
        NSLog(@"Delete message error %@, %@", error, [error userInfo]);
    }
    _fetchedResultsController.delegate = self;              // reconnect after mass delete
    if (![_fetchedResultsController performFetch:&error]) { // resync controller
        // TODO: Handle the error appropriately.
        NSLog(@"fetchMessages error %@, %@", error, [error userInfo]);
    }
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    _arrayOfAssets = [[NSMutableArray alloc] init];
    UIBarButtonItem* deleteBarbottun = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteImage)];
    self.navigationItem.leftBarButtonItem = deleteBarbottun;
    
    UIBarButtonItem* refleshBarbottun = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refleshImage)];
    self.navigationItem.rightBarButtonItem = refleshBarbottun;
    _assetsMngr = [AssetManager sharedAssetManager];
    _assetsMngr.delegate = self;
    [_assetsMngr setAssetManagerModeIsHoldItemData:YES];


    CoreDataMngr* coreDataMngr = [CoreDataMngr sharedCoreDataMngr];
    NSArray* sortNames = @[@"dateTime",@"model"];
    _fetchedResultsController = [coreDataMngr fetchedResultsController:self entityName:@"InageInfo" sectionName:@"sectionIdentifire" sort:sortNames cashe:nil];
    [coreDataMngr performFetch];
    
}


- (void)viewWillAppear {
    
    [self.tableView reloadData];
}

- (void)viewDidUnload {
    
    // Release any properties that are loaded in viewDidLoad or can be recreated lazily.
    self.fetchedResultsController = nil;
}

- (void)refleshImage
{
    [_assetsMngr enumeAssetItems];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    //[self refresh:nil];
    NSLog(@"fetch sections: %d",[[self.fetchedResultsController sections] count]);
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    NSLog(@"fetch rows: %d",sectionInfo.numberOfObjects);
    return sectionInfo.numberOfObjects;
}

- (void)configureCell:(ImageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell to show the book's title
    InageInfo* imageInfo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.thumbnailView.image = imageInfo.thunbnail;
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
    [inputDateFormatter setDateFormat:@"yyyy/MM/dd"];
    cell.DateTimeLabel.text = [inputDateFormatter stringFromDate:imageInfo.dateTime];
    cell.cameraModelLabel.text = imageInfo.model;
    cell.makerLabel.text = imageInfo.maker;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImageTableViewCell* cell = (ImageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"baseTableCell" forIndexPath:indexPath];
    
    // Configure the cell...
    InageInfo* imageInfo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSURL* url = [NSURL URLWithString:imageInfo.url];
    UIImage* image = [_assetsMngr getThumbnail:url];
    cell.thumbnailView.image = image;
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
    [inputDateFormatter setDateFormat:@"yyyy/MM/dd"];
    cell.DateTimeLabel.text = [inputDateFormatter stringFromDate:imageInfo.dateTime];
    cell.cameraModelLabel.text = imageInfo.model;
    cell.makerLabel.text = imageInfo.maker;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
/*
    // Display the authors' names as section headings.
	id <NSFetchedResultsSectionInfo> theSection = [[self.fetchedResultsController sections] objectAtIndex:section];
    static NSDateFormatter *formatter = nil;
    
    if (!formatter)
    {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setCalendar:[NSCalendar currentCalendar]];
        
        NSString *formatTemplate = [NSDateFormatter dateFormatFromTemplate:@"MMMM YYYY" options:0 locale:[NSLocale currentLocale]];
        [formatter setDateFormat:formatTemplate];
    }
    
    NSInteger numericSection = [[theSection name] integerValue];
	NSInteger year = numericSection / 1000;
	NSInteger month = numericSection - (year * 1000);
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = year;
    dateComponents.month = month;
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
    
	NSString *titleString = [formatter stringFromDate:date];
    
	return titleString;
*/
    return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
}


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(ImageTableViewCell*)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
