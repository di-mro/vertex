//
//  AssetConfigurationPageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 3/30/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "AssetConfigurationPageViewController.h"

@interface AssetConfigurationPageViewController ()

@end

@implementation AssetConfigurationPageViewController

@synthesize assetConfigPageEntries;

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
  NSLog(@"Asset Configurations Page View");
  
  [self displayAssetConfigPageEntries];
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

# pragma mark - Display entries in Asset Config Page
- (void) displayAssetConfigPageEntries
{
  assetConfigPageEntries = [[NSMutableArray alloc] init];
  
  /* !- For demo only, remove hard coded values. Must retrieve listing in DB -! */
  NSString *entry1 = @"Update Asset Accountability";
  NSString *entry2 = @"Update Asset Ownership";
  NSString *entry3 = @"Remove Asset";
  NSString *entry4 = @"Add Asset Type";
  NSString *entry5 = @"View Asset Type";
  NSString *entry6 = @"Update Asset Type";
  NSString *entry7 = @"Remove Asset Type";
  
  [assetConfigPageEntries addObject:entry1];
  [assetConfigPageEntries addObject:entry2];
  [assetConfigPageEntries addObject:entry3];
  [assetConfigPageEntries addObject:entry4];
  [assetConfigPageEntries addObject:entry5];
  [assetConfigPageEntries addObject:entry6];
  [assetConfigPageEntries addObject:entry7];
}

#pragma mark - Table view data source implementation
- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
  //Return the number of sections.
  return 1;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
  NSString *myTitle = [[NSString alloc] initWithFormat:@"Asset Configuration"];
  return myTitle;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Return the number of rows in the section
  return [assetConfigPageEntries count];
  NSLog(@"%d", [assetConfigPageEntries count]);
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"assetConfigPageCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //configure the cell
  cell.textLabel.text = [self.assetConfigPageEntries objectAtIndex:indexPath.row];
  cell.textLabel.numberOfLines = 0;
  return cell;
}


//Change the Height of the Cell [Default is 45]:
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
  return 50;
}


#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  switch (indexPath.row)
  {
    //Update Asset Accountability
    case 0: [self performSegueWithIdentifier:@"assetConfigToUpdateAssetAccountability" sender:self];
      break;
    //Update Asset Ownership
    case 1: [self performSegueWithIdentifier:@"assetConfigToUpdateAssetOwnership" sender:self];
      break;
    //Remove Asset
    case 2: [self performSegueWithIdentifier:@"assetConfigToDeleteAsset" sender:self];
      break;
    //Add Asset Type
    case 3: [self performSegueWithIdentifier:@"assetConfigToAddAssetType" sender:self];
       break;
    //View Asset Type
    case 4: [self performSegueWithIdentifier:@"assetConfigToViewAssetType" sender:self];
       break;
    //Update Asset Type
    case 5: [self performSegueWithIdentifier:@"assetConfigToUpdateAssetType" sender:self];
       break;
    //Remove Asset Type
    case 6: [self performSegueWithIdentifier:@"assetConfigToRemoveAssetType" sender:self];
       break;
    default: break;
  }  
}


@end
