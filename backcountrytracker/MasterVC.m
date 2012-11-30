//
//  MasterVC.m
//  backcountrytracker
//
//  Created by Matthew Propst on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MasterVC.h"
#import "DetailViewController.h"

@interface MasterVC ()

@end

@implementation MasterVC
@synthesize help;
@synthesize stop;
@synthesize settings;
@synthesize tabbar;
@synthesize locationManager;


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
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [help addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item == settings) {
        NSLog(@"settings");
        DetailViewController *dvc = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
        [self.navigationController pushViewController:dvc animated:YES];
        tabbar.selectedItem = nil;
        
    }
    if(item == stop){
        NSLog(@"reset all defaults -- trip's over.");
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:@"Delete Values"];
        [alert setMessage:@"Please confirm you've ended your trip.  You will delete all of your stored values."];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"OK"];
        [alert addButtonWithTitle:@"Cancel"];
		[alert show];
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
		// Yes, do something
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary * dict = [defaults dictionaryRepresentation];
        for (id key in dict) {
            [defaults removeObjectForKey:key];
        }
        [defaults synchronize];
       
	}
	else if (buttonIndex == 1)
	{
		// No
	}
}

#pragma Location Methods:

- (NSString *)getLastLocation{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    NSLog(@"LAT: %f", [locationManager location].coordinate.latitude);
    NSString *latitude = [NSString stringWithFormat:@"%f", [locationManager location].coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", [locationManager location].coordinate.longitude];
    NSString *latlong = [NSString stringWithFormat:@"%@,%@", latitude, longitude];
    NSLog(@"LONG: %f", [locationManager location].coordinate.longitude);
    NSLog(@"Combined Location: %@", latlong);
    return latlong;
}

#pragma mark - CLLOCATION STUFF
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.currentLocation = newLocation;
    
    if(newLocation.horizontalAccuracy <= 100.0f) { [locationManager stopUpdatingLocation]; }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if(error.code == kCLErrorDenied) {
        [locationManager stopUpdatingLocation];
    } else if(error.code == kCLErrorLocationUnknown) {
        // retry
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error retrieving location"
                                                        message:[error description]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

#pragma MFMessage Delegate Methods

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	[self dismissModalViewControllerAnimated:YES];
    
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
    else if (result == MessageComposeResultSent)
        NSLog(@"Message sent");  
    else 
        NSLog(@"Message failed");
}


- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = bodyOfMessage;    
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self presentModalViewController:controller animated:YES];
    }    
}


- (void)buttonPressed:(UIButton *)button
{
	if (button == help)
    {
		[self sendSMS:        [NSString stringWithFormat:(@"THIS IS A DISTRESS MESSAGE SENT FROM BACKCOUNTY TRACKER: -- \nTrip Name: %@\nTrip Location: %@\nLast Location: %@" ),[[NSUserDefaults standardUserDefaults] objectForKey:@"tripName"], [[NSUserDefaults standardUserDefaults] objectForKey:@"tripLocation"], [self getLastLocation]]
 recipientList:[NSArray arrayWithObjects:[[NSUserDefaults standardUserDefaults] objectForKey:@"contact"], nil]];
    }
}


@end
