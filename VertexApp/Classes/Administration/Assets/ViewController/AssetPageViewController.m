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
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  NSLog(@"Asset Page View");
  
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
  
  /* !- For demo only, remove hard coded values. Must retrieve listing in DB -! */
  NSString *entry1 = @"Add Asset";
  NSString *entry2 = @"View Assets";
  NSString *entry3 = @"Update Asset";
  //NSString *entry4 = @"Delete Assets";
  
  [assetPageEntries addObject:entry1];
  [assetPageEntries addObject:entry2];
  [assetPageEntries addObject:entry3];
  //[assetPageEntries addObject:entry4];
}

#pragma mark - Table view data source implementation
- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
  return 1;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
  NSString *myTitle = [[NSString alloc] initWithFormat:@""];
  return myTitle;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [assetPageEntries count];
  NSLog(@"%d", [assetPageEntries count]);
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"assetPageCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier  forIndexPath:indexPath];
  
  //Configure the cell display
  cell.textLabel.text = [self.assetPageEntries objectAtIndex:indexPath.row];
  cell.textLabel.numberOfLines = 0;
  return cell;
}

#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  switch (indexPath.row)
  {
    //Add
    case 0: [self performSegueWithIdentifier:@"assetsToAddAsset" sender:self];
      break;
    //View
    case 1: [self performSegueWithIdentifier:@"assetsToViewAssets" sender:self];
      break;
    //Update
    case 2: [self performSegueWithIdentifier:@"assetsToUpdateAsset" sender:self];
      break;
    //case 3: [self performSegueWithIdentifier:@"assetsToViewAssets" sender:self];
    //  break;
    default: break;
  }
}

@end
