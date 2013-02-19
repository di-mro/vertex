//
//  HomePageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 2/13/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "HomePageViewController.h"

@interface HomePageViewController ()

@end

@implementation HomePageViewController

@synthesize homePageEntries;

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
  self.navigationItem.hidesBackButton = YES;
  [self displayHomePageEntries];
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Display entries in Home Page
- (void) displayHomePageEntries
{
  homePageEntries = [[NSMutableArray alloc] init];
  
  //!-For demo only, remove hard coded values-!
  NSString *entry1 = @"Asset";
  NSString *entry2 = @"Service Request";
  NSString *entry3 = @"Notices";
  NSString *entry4 = @"Billing";
  NSString *entry5 = @"Schedule";
  NSString *entry6 = @"Administration";
  NSString *entry7 = @"Options/Configurations";
  //NSStrign *entry8 = @"Logout";
  
  [homePageEntries addObject:entry1];
  [homePageEntries addObject:entry2];
  [homePageEntries addObject:entry3];
  [homePageEntries addObject:entry4];
  [homePageEntries addObject:entry5];
  [homePageEntries addObject:entry6];
  [homePageEntries addObject:entry7];
}


#pragma mark - Table view data source
- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
  //Return the number of sections.
  return 1;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
  //NSString *myTitle = [[NSString alloc] initWithFormat:@"Home"];
  NSString *myTitle = [[NSString alloc] initWithFormat:@""];
  return myTitle;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Return the number of rows in the section
  return [homePageEntries count];
  NSLog(@"%d", [homePageEntries count]);
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"Home Page View");
  static NSString *CellIdentifier = @"homePageCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //configure the cell
  cell.textLabel.text = [self.homePageEntries objectAtIndex:indexPath.row];
  cell.textLabel.numberOfLines = 0;
  return cell;
}

#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  //!-Remove these hardcoded shiznitz-!
  switch (indexPath.row)
  {
    //Home
    case 0: [self performSegueWithIdentifier:@"homeToAssets" sender:self];
      break;
    //Service Request
    case 1: [self performSegueWithIdentifier:@"homeToServiceRequest" sender:self];
      break;
    //Notices
    case 2: [self performSegueWithIdentifier:@"homeToServiceRequest" sender:self];
      break;
    //Billing
    case 3: [self performSegueWithIdentifier:@"homeToServiceRequest" sender:self];
      break;
    //Schedule
    case 4: [self performSegueWithIdentifier:@"homeToServiceRequest" sender:self];
      break;
    //Administration
    case 5: [self performSegueWithIdentifier:@"homeToServiceRequest" sender:self];
      break;
    //Options/Configurations
    case 6: [self performSegueWithIdentifier:@"homeToServiceRequest" sender:self];
      break;
    default: break;
  }
}


@end
