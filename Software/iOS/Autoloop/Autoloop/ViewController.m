//
//  ViewController.m
//  Autoloop
//
//  Created by Josh Billions on 2/1/15.
//  Copyright (c) 2015 Catalyze Chicago. All rights reserved.
//

#import "ViewController.h"
#import "MSGridView.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Block.h"
#import "SequencerController.h"

@interface ViewController () <MSGridViewDataSource, MSGridViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) SequencerController *sequencer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gridView.gridViewDelegate = self;
    self.gridView.gridViewDataSource = self;
    [[self gridView] setInnerSpacing:CGSizeMake(0.0f, 0.0f)];
    
    self.sequencer = [[SequencerController alloc] init];
    self.sequencer.gridView = self.gridView;
    
    NSError *fetchError = nil;
    [[self fetchedResultsController] performFetch:&fetchError];
    if(fetchError){
        NSLog(@"Error fetching: %@", fetchError);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark gridView datasource methods


-(MSGridViewCell *)cellForIndexPath:(NSIndexPath*)indexPath inGridWithIndexPath:(NSIndexPath *)gridIndexPath;
{
    
    static NSString *reuseIdentifier = @"cell";
    MSGridViewCell *cell = [MSGridView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if(cell == nil) {
        cell = [[MSGridViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier];
    }
    
    cell.backgroundColor = [UIColor blackColor];
    cell.layer.borderColor = [UIColor darkGrayColor].CGColor;
    cell.layer.borderWidth = 2;
    
    return cell;
    
}

-(NSUInteger)numberOfGridRows{
    return 1;
}

-(NSUInteger)numberOfGridColumns{
    return 1;
}


-(NSUInteger)numberOfColumnsForGridAtIndexPath:(NSIndexPath*)indexPath{
    return 16;
}

-(NSUInteger)numberOfRowsForGridAtIndexPath:(NSIndexPath*)indexPath{
    return 9;
}

-(float)heightForCellRowAtIndex:(NSUInteger)row forGridAtIndexPath:(NSIndexPath *)gridIndexPath{
    return 35.0f;
}

-(float)widthForCellColumnAtIndex:(NSUInteger)column forGridAtIndexPath:(NSIndexPath *)gridIndexPath{
    return 20.0f;
}

-(void)didSelectCellWithIndexPath:(NSIndexPath*) indexPath{
    int row = (int)[indexPath indexAtPosition:2];
    int column;
    if ([indexPath indexAtPosition:1] == 1) {
        column = (int)[indexPath indexAtPosition:3] + 16;
    }else{
        column = (int)[indexPath indexAtPosition:3];
    }
    
    MSGridViewCell *cell = [self.gridView cellAtIndexPath:indexPath];
    
    Block *savedBlock = [self fetchBlockAtRow:row column:column];
    
    if(!savedBlock){
        [self saveBlockAtRow:row column:column state:cell.active];
    }else{
        savedBlock.active = [NSNumber numberWithBool:cell.active];
    }
    
    if (cell.active) {
        cell.backgroundColor = [UIColor redColor];
    }else{
        cell.backgroundColor = [UIColor blackColor];
    }
}

#pragma mark - IBActions

-(IBAction)startStopTapped:(id)sender{
    if ([self.startStopButton.titleLabel.text isEqualToString:@"Start"]) {
        [self.startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
    }else{
        [self.startStopButton setTitle:@"Start" forState:UIControlStateNormal];
    }
    
    [self.sequencer startStopToggled];
}


-(void)sliderChanged:(id)sender{
    self.bpmLabel.text = [NSString stringWithFormat:@"%i", (int)self.bpmSlider.value];
    self.sequencer.currentBPM = [NSNumber numberWithInt:(int)self.bpmSlider.value];
}

-(void)clearAll:(id)sender{
    for(NSIndexPath *indexPath in [[self.gridView gridCells] allKeys]){
        MSGridViewCell *cell = [self.gridView cellAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor blackColor];
        cell.active = NO;
    }

}

#pragma mark - Block Fetching and Saving

-(Block *)fetchBlockAtRow:(int)row column:(int)column{
    NSManagedObjectContext *context = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Block" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(row == %i) AND (column == %i)", row, column];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *array = [context executeFetchRequest:request error:&error];
    if (array != nil) {
        NSUInteger count = [array count]; // May be 0 if the object has been deleted.
        if (count == 0) {
            return nil;
        }else{
            return [array firstObject];
        }
    }
    else {
        // Deal with error.
    }
    return nil;
}

-(void)saveBlockAtRow:(int)row column:(int)column state:(bool)isActive{
    NSManagedObjectContext *context = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Block" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"(row == %i) AND (column == %i)", row, column];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *array = [context executeFetchRequest:request error:&error];
    if (array != nil) {
        NSUInteger count = [array count]; // May be 0 if the object has been deleted.
        if (count == 0) {
            Block *newBlock = [NSEntityDescription insertNewObjectForEntityForName:@"Block" inManagedObjectContext:context];
            newBlock.row = [NSNumber numberWithInt:row];
            newBlock.column = [NSNumber numberWithInt:column];
            newBlock.active = [NSNumber numberWithBool:isActive];
            //            NSError *saveError = nil;
            //            if (![context save:&saveError]) {
            //                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            //                abort();
            //            }
        }
    }
    else {
        // Deal with error.
    }
}


#pragma mark - Fetched Results Controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSManagedObjectContext *context = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Block" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:144];
    
    //Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"active" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:@"SavedTVCCache"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}


@end
