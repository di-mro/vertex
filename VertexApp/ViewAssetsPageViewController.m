//
//  ViewAssetsPageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 2/13/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "ViewAssetsPageViewController.h"

@interface ViewAssetsPageViewController ()

@end

@implementation ViewAssetsPageViewController

@synthesize viewAssetsPageEntries;

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
  [self displayViewAssetsPageEntries];
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Display entries in Asset Page
- (void) displayViewAssetsPageEntries
{
  viewAssetsPageEntries = [[NSMutableArray alloc] init];
  
  /* !- For demo only, remove hard coded values. Must retrieve listing in DB -! */
  NSString *entry1 = @"Aircon";
  NSString *entry2 = @"Bath Tub";
  NSString *entry3 = @"Kitchen Sink";
  NSString *entry4 = @"Window";
  
  [viewAssetsPageEntries addObject:entry1];
  [viewAssetsPageEntries addObject:entry2];
  [viewAssetsPageEntries addObject:entry3];
  [viewAssetsPageEntries addObject:entry4];
}

#pragma mark - Table view data source implementation
- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
  //Return the number of sections.
  return 1;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
  NSString *myTitle = [[NSString alloc] initWithFormat:@"Assets List"];
  return myTitle;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Return the number of rows in the section
  return [viewAssetsPageEntries count];
  NSLog(@"%d", [viewAssetsPageEntries count]);
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"View Assets Page View");
  static NSString *CellIdentifier = @"viewAssetsPageCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //configure the cell
  cell.textLabel.text = [self.viewAssetsPageEntries objectAtIndex:indexPath.row];
  cell.textLabel.numberOfLines = 0;
  return cell;
}

#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self performSegueWithIdentifier:@"viewAssetsToSingleAsset" sender:self];
  
  /* 
   !- TODO -!
   Call a function to populate the fields inn Single Asset View
   Remove hardcoded fields in Single Asset View Storyboard
   */
}


@end
