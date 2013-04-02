//
//  EsseInfoConfigurationViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 3/30/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "EsseInfoConfigurationViewController.h"

@interface EsseInfoConfigurationViewController ()

@end

@implementation EsseInfoConfigurationViewController

@synthesize esseInfoConfigPageEntries;

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
  NSLog(@"Esse Info Configuration Page View");
  
  [self displayEsseInfoConfigPageEntries];
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

# pragma mark - Display entries in Admin Page
- (void) displayEsseInfoConfigPageEntries
{
  esseInfoConfigPageEntries = [[NSMutableArray alloc] init];
  
  /* !- For demo only, remove hard coded values. Must retrieve listing in DB -! */
  NSString *entry1 = @"Add Esse";
  NSString *entry2 = @"View Esse";
  NSString *entry3 = @"Update Esse";
  NSString *entry4 = @"Remove Esse";
  
  [esseInfoConfigPageEntries addObject:entry1];
  [esseInfoConfigPageEntries addObject:entry2];
  [esseInfoConfigPageEntries addObject:entry3];
  [esseInfoConfigPageEntries addObject:entry4];
}

#pragma mark - Table view data source implementation
- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
  //Return the number of sections.
  return 1;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
  NSString *myTitle = [[NSString alloc] initWithFormat:@"Esse Info Management"];
  return myTitle;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Return the number of rows in the section
  return [esseInfoConfigPageEntries count];
  NSLog(@"%d", [esseInfoConfigPageEntries count]);
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"esseInfoConfigPageCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //configure the cell
  cell.textLabel.text = [self.esseInfoConfigPageEntries objectAtIndex:indexPath.row];
  cell.textLabel.numberOfLines = 0;
  return cell;
}

#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  switch (indexPath.row)
  {
      /*
       //Add Service
       case 0: [self performSegueWithIdentifier:@"" sender:self];
       break;
       case 1: [self performSegueWithIdentifier:@"" sender:self];
       break;
       case 2: [self performSegueWithIdentifier:@"" sender:self];
       break;
       case 3: [self performSegueWithIdentifier:@"" sender:self];
       break;
       default: break;
       */
  }
}


@end
