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

- (void) loadInitialData
{
    [self unarchive];
    /*
    XYZToDoItem *item1 = [[XYZToDoItem alloc] init];
    item1.itemName = @"Buy Candles";
    [self.toDoItems addObject: item1];
    
    XYZToDoItem *item2 = [[XYZToDoItem alloc] init];
    item2.itemName = @"Perform Seance";
    [self.toDoItems addObject: item2];
    
    XYZToDoItem *item3 = [[XYZToDoItem alloc] init];
    item3.itemName = @"Sharpen Athame";
    [self.toDoItems addObject: item3];
     */
    
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
    
    [self loadInitialData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    /*if ([self.toDoItems count] != 0 && [self.completedToDoItems count] != 0)
        return 2;
    else if ([self.toDoItems count] != 0 || [self.completedToDoItems count] != 0)
        return 1;
    else
        return 1;*/
    return 2;
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
    // Configure the cell...
    
    return cell;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
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

#pragma mark - Table view delegate


//toggles toDoItem's between sections and states of completion when selected
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: NO];

    if (indexPath.section == 0){
        XYZToDoItem *tappedItem = [self.toDoItems objectAtIndex: indexPath.row];
        tappedItem.completed = !tappedItem.completed;
        [self.completedToDoItems addObject: tappedItem];
        [self.toDoItems removeObjectAtIndex: indexPath.row];
    }
    else if (indexPath.section == 1){
        XYZToDoItem *tappedItem = [self.completedToDoItems objectAtIndex: indexPath.row];
        tappedItem.completed = !tappedItem.completed;
        [self.toDoItems addObject: tappedItem];
        [self.completedToDoItems removeObjectAtIndex: indexPath.row];
    }
    [self archive];
    [tableView reloadData];
}

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
