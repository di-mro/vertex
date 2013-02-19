//
//  AssetPageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 2/13/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "AssetPageViewController.h"

@interface AssetPageViewController ()

@end

@implementation AssetPageViewController

@synthesize assetPageEntries;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [self displayAssetPageEntries];
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - Display entries in Asset Page
- (void) displayAssetPageEntries
{
  assetPageEntries = [[NSMutableArray alloc] init];
  
  //!-For demo only, remove hard coded values-!
  NSString *entry1 = @"View Asset";
  NSString *entry2 = @"Add Assets";
  
  [assetPageEntries addObject:entry1];
  [assetPageEntries addObject:entry2];
}

#pragma mark - Table view data source
- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
  //Return the number of sections.
  return 1;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
  //NSString *myTitle = [[NSString alloc] initWithFormat:@"Assets Page"];
  NSString *myTitle = [[NSString alloc] initWithFormat:@""];
  return myTitle;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Return the number of rows in the section
  return [assetPageEntries count];
  NSLog(@"%d", [assetPageEntries count]);
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"Asset Page View");
  static NSString *CellIdentifier = @"assetPageCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //configure the cell
  cell.textLabel.text = [self.assetPageEntries objectAtIndex:indexPath.row];
  cell.textLabel.numberOfLines = 0;
  return cell;
}

#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  switch (indexPath.row) {
    case 0: [self performSegueWithIdentifier:@"assetsToViewAssets" sender:self];
      break;
    case 1: [self performSegueWithIdentifier:@"assetsToAddAsset" sender:self];
      break;
    default: break;
  }
}

@end
