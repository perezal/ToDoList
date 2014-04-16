//
//  XYZToDoItemTableViewController.m
//  ToDoList
//
//  Created by Alex Perez on 3/29/14.
//  Copyright (c) 2014 Alex Perez. All rights reserved.
//

#import "XYZToDoItemTableViewController.h"
#import "XYZAddToDoItemViewController.h"
#import "XYZToDoItem.h"

@interface XYZToDoItemTableViewController ()

@property NSMutableArray *toDoItems, *completedToDoItems;

-(void) archive;
-(void) unarchive;

@end

@implementation XYZToDoItemTableViewController


-(IBAction) unwindToList:(UIStoryboardSegue *)segue
{
    XYZAddToDoItemViewController *source = [segue sourceViewController];
    XYZToDoItem *item = source.toDoItem;
    
    if (item != nil){
        [self.toDoItems addObject: item];
        [self.tableView reloadData];
        [self archive];
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.toDoItems = [[NSMutableArray alloc] init];
    self.completedToDoItems = [[NSMutableArray alloc] init];
    
    [self unarchive];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    /*
    // eliminates the superfluous section header when either toDoItems array is empty
    // currently not working with present didSelectRowAtIndexPath
    if ([self.completedToDoItems count] == 0)
        return 1;
    else
        return 2;
     */
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return [self.toDoItems count];
    else if (section == 1)
        return [self.completedToDoItems count];
    else
        return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"To-Do";
    else
        return @"Completed";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ListPrototypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier forIndexPath:indexPath];
    
    if (indexPath.section == 0){
        XYZToDoItem *toDoItem = [self.toDoItems objectAtIndex: indexPath.row];
        cell.textLabel.text = toDoItem.itemName;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else{
        XYZToDoItem *toDoItem = [self.completedToDoItems objectAtIndex: indexPath.row];
        cell.textLabel.text = toDoItem.itemName;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

# pragma mark - Edit button methods

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section == 0)
            [self.toDoItems removeObjectAtIndex: indexPath.row];
        else
            [self.completedToDoItems removeObjectAtIndex: indexPath.row];
        
        [self archive];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    } /*else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   */
}


#pragma mark - Table view delegate


//toggles toDoItem's between sections and states of completion when selected
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: NO];

    if (indexPath.section == 0){
        XYZToDoItem *tappedItem = [self.toDoItems objectAtIndex: indexPath.row];
        
        tappedItem.completed = !tappedItem.completed;
        [tableView cellForRowAtIndexPath: indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        
        [self.completedToDoItems addObject: tappedItem];
        [self.toDoItems removeObjectAtIndex: indexPath.row];
        
        [tableView moveRowAtIndexPath:indexPath toIndexPath: [NSIndexPath indexPathForRow:[self.completedToDoItems indexOfObject: tappedItem] inSection:1]];
    }
    else if (indexPath.section == 1){
        XYZToDoItem *tappedItem = [self.completedToDoItems objectAtIndex: indexPath.row];
        
        tappedItem.completed = !tappedItem.completed;
        [tableView cellForRowAtIndexPath: indexPath].accessoryType = UITableViewCellAccessoryNone;
        
        [self.toDoItems addObject: tappedItem];
        [self.completedToDoItems removeObjectAtIndex: indexPath.row];
        
        [tableView moveRowAtIndexPath:indexPath toIndexPath: [NSIndexPath indexPathForRow:[self.toDoItems indexOfObject: tappedItem] inSection:0]];
    }
    [self archive];
    //[tableView reloadData];
}

# pragma mark - archival methods

- (void) archive
{
    NSURL *dataFileURL = [[[[NSFileManager defaultManager] URLsForDirectory: NSDocumentDirectory inDomains: NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"toDoData"];

    NSMutableData *dataArea = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData: dataArea];
    
    [archiver encodeObject: _toDoItems forKey:@"ToDoItems"];
    [archiver encodeObject: _completedToDoItems forKey: @"CompletedToDoItems"];
    [archiver finishEncoding];
    
    if ([dataArea writeToFile: [dataFileURL path] atomically: YES] == NO)
        NSLog (@"Archiving Failed");
    
}

- (void) unarchive
{
    NSURL *dataFileURL = [[[[NSFileManager defaultManager] URLsForDirectory: NSDocumentDirectory inDomains: NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"toDoData"];
    
    NSData *dataArea = [NSData dataWithContentsOfFile: [dataFileURL path]];
    if (!dataArea)
        NSLog(@"Read data failed");

    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData: dataArea];
    
    self.toDoItems = [unarchiver decodeObjectForKey: @"ToDoItems"];
    self.completedToDoItems = [unarchiver decodeObjectForKey: @"CompletedToDoItems"];
    [unarchiver finishDecoding];
}

@end
