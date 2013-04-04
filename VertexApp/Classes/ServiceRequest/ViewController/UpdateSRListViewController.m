//
//  UpdateSRListViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 4/2/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "UpdateSRListViewController.h"

@interface UpdateSRListViewController ()

@end

@implementation UpdateSRListViewController

@synthesize displayUpdateSREntries;
@synthesize displayUpdateSRSubtitles;

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
  [self displayUpdateSRPageEntries];
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - Display entries for update in Service Requests List Page
- (void) displayUpdateSRPageEntries
{
  /* !- TODO For demo only, remove hard coded values-! */
  displayUpdateSREntries = [[NSMutableArray alloc] init];
  NSString *entry1 = @"Aircon Fix";
  NSString *entry2 = @"Leaking Faucet";
  NSString *entry3 = @"Broken Window";
  
  [displayUpdateSREntries addObject:entry1];
  [displayUpdateSREntries addObject:entry2];
  [displayUpdateSREntries addObject:entry3];
  
  /* !- TODO For the subtitles/details, remove these hard coded values -! */
  displayUpdateSRSubtitles = [[NSMutableArray alloc] init];
  NSString *sub1 = @"2013-01-08";
  NSString *sub2 = @"2013-02-15";
  NSString *sub3 = @"2013-02-16";
  
  [displayUpdateSRSubtitles addObject:sub1];
  [displayUpdateSRSubtitles addObject:sub2];
  [displayUpdateSRSubtitles addObject:sub3];
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
  return [displayUpdateSREntries count];
  NSLog(@"%d", [displayUpdateSREntries count]);
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"Service Requests for Update Page View");
  static NSString *CellIdentifier = @"updateSRListCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //Configure the cell title & subtitle
  cell.textLabel.text = [self.displayUpdateSREntries objectAtIndex:indexPath.row];
  cell.detailTextLabel.text = [self.displayUpdateSRSubtitles objectAtIndex:indexPath.row];
  cell.textLabel.numberOfLines = 0;
  return cell;
}

#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self performSegueWithIdentifier:@"updateSRListToUpdateSRPage" sender:self];
  
}


#pragma mark - prepare for segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"updateSRListToUpdateSRPage"])
  {
    //[segue.destinationViewController setLifecycleId:selectedLifecycleId];
  }
}



@end
