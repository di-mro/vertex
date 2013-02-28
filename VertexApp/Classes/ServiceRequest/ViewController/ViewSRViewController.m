//
//  ViewSRViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 2/15/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "ViewSRViewController.h"

@interface ViewSRViewController ()

@end

@implementation ViewSRViewController

@synthesize displaySREntries;
@synthesize displaySRSubtitles;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [self displaySRPageEntries];
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Display entries in Service Requests List Page
- (void) displaySRPageEntries
{
  /* !- TODO For demo only, remove hard coded values-! */
  displaySREntries = [[NSMutableArray alloc] init];
  NSString *entry1 = @"Aircon Fix";
  NSString *entry2 = @"Leaking Faucet";
  NSString *entry3 = @"Broken Window";
   
  [displaySREntries addObject:entry1];
  [displaySREntries addObject:entry2];
  [displaySREntries addObject:entry3];
  
  /* !- TODO For the subtitles/details, remove these hard coded values -! */
  displaySRSubtitles = [[NSMutableArray alloc] init];
  NSString *sub1 = @"2013-01-08";
  NSString *sub2 = @"2013-02-15";
  NSString *sub3 = @"2013-02-16";
  
  [displaySRSubtitles addObject:sub1];
  [displaySRSubtitles addObject:sub2];
  [displaySRSubtitles addObject:sub3];
}

#pragma mark - Table view data source implementation
- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
  //Return the number of sections.
  return 1;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
  NSString *myTitle = [[NSString alloc] initWithFormat:@"Service Request List"];
  return myTitle;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Return the number of rows in the section
  return [displaySREntries count];
  NSLog(@"%d", [displaySREntries count]);
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"View Assets Page View");
  static NSString *CellIdentifier = @"viewSRCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //Configure the cell title & subtitle
  cell.textLabel.text = [self.displaySREntries objectAtIndex:indexPath.row];
  cell.detailTextLabel.text = [self.displaySRSubtitles objectAtIndex:indexPath.row];
  cell.textLabel.numberOfLines = 0;
  return cell;
}

#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self performSegueWithIdentifier:@"viewSRToDisplaySR" sender:self];
  
  /* !- TODO
     Call some function to populate the fields inn Single Asset View
     Remove hardcoded fields in Single Asset View Storyboard
  -! */
}


@end
