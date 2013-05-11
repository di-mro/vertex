//
//  HomePageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 2/13/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "HomePageViewController.h"
#import "LoginViewController.h"

@interface HomePageViewController ()

@end

@implementation HomePageViewController

@synthesize homePageEntries;
@synthesize homePageIcons;

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
  NSLog(@"Home Page View");

  //[Logout] button initialization
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
  
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

  NSString *entry1 = @" Notification";
  NSString *entry2 = @" Service Request";
  NSString *entry3 = @" Asset";
  NSString *entry4 = @" Billing";
  NSString *entry5 = @" Reports";
  NSString *entry6 = @" Administration";
  NSString *entry7 = @" Schedule";
  NSString *entry8 = @" Settings";
  
  [homePageEntries addObject:entry1];
  [homePageEntries addObject:entry2];
  [homePageEntries addObject:entry3];
  [homePageEntries addObject:entry4];
  [homePageEntries addObject:entry5];
  [homePageEntries addObject:entry6];
  [homePageEntries addObject:entry7];
  [homePageEntries addObject:entry8];
  
  
  homePageIcons = [[NSMutableArray alloc] initWithObjects:@"notification_icon.png"
                                                         , @"service_request_icon.png"
                                                         , @"asset_icon.png"
                                                         , @"billing_icon.png"
                                                         , @"reports_icon.png"
                                                         , @"administration_icon.png"
                                                         , @"schedule_icon.png"
                                                         , @"settings_icon.png" ,nil];
}


#pragma mark - Table view data source implementation
- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
  //Return the number of sections.
  return 1;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
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
  static NSString *CellIdentifier = @"homePageCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //configure the cell
  
  cell.textLabel.text = [self.homePageEntries objectAtIndex:indexPath.row];
  cell.imageView.image = [UIImage imageNamed:(NSString*)[self.homePageIcons objectAtIndex:indexPath.row]];
  
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
    //Notifications
    case 0: [self performSegueWithIdentifier:@"homeToNotices" sender:self];
      break;
    //Service Request
    case 1: [self performSegueWithIdentifier:@"homeToServiceRequest" sender:self];
      break;
    //Asset
    case 2: [self performSegueWithIdentifier:@"homeToAssets" sender:self];
      break;
    //Billing
    case 3: [self performSegueWithIdentifier:@"homeToBilling" sender:self];
      break;
    //Reports
    case 4: [self performSegueWithIdentifier:@"homeToReports" sender:self];
      break;
    //Administration
    case 5: [self performSegueWithIdentifier:@"homeToAdmin" sender:self];
      break;
    //Schedule
    case 6: [self performSegueWithIdentifier:@"homeToSchedule" sender:self];
      break;
    //Settings
    case 7: [self performSegueWithIdentifier:@"homeToSettings" sender:self];
      break;
    default: break;
  }
}

#pragma mark - [Logout] button logic implementation
-(void) logout
{
  NSLog(@"Logout");
  
  //Go back to Login Page
  LoginViewController* controller = (LoginViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"LoginPage"];
  
  controller.navigationItem.hidesBackButton = YES;
  [self.navigationController pushViewController:controller animated:YES];
    
  /* !- TODO -!
   Clear user tokens/objects when [Logout] is pressed
   */
}


@end
