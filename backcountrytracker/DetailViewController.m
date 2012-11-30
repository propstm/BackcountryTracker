//
//  DetailViewController.m
//  backcountrytracker
//
//  Created by Matthew Propst on 11/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController
@synthesize tname;
@synthesize tlocation;
@synthesize description;
@synthesize contactName;
@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;


- (void)dealloc
{
    [_detailItem release];
    [_detailDescriptionLabel release];
    [super dealloc];
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        [_detailItem release]; 
        _detailItem = [newDetailItem retain]; 

        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"contact"] != nil){
        description.text = [defaults objectForKey:@"contact"];
    }else{
        [self.description setPlaceholder:@"Description"];
    }
    
    
    if([defaults objectForKey:@"tripName"] != nil){
        tname.text = [defaults objectForKey:@"tripName"];
    }else{
       [tname setPlaceholder:@"Trip Name"];
    }
    
    if([defaults objectForKey:@"tripLocation"] != nil){
        tlocation.text = [defaults objectForKey:@"tripLocation"];
    }else{
        [tlocation setPlaceholder:@"Trip Location"];
        
    }
}


- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    // assigning control back to the main controller
	[self dismissModalViewControllerAnimated:YES];
}

- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
	
	// setting the first name
    NSString *firstName = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
	
	// setting the last name
    NSString *lastName = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
	
	contactName.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
	
	//if you do not set a number for a contact it will probably crash
    // MITIGATE THIS!
    
	ABMultiValueRef multi = ABRecordCopyValue(person, kABPersonPhoneProperty);
	description.text = (NSString*)ABMultiValueCopyValueAtIndex(multi, 0);
    
    [self setDefaultValues];
    
	// remove the controller
    [self dismissModalViewControllerAnimated:YES];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (void)setPickerViewAsFirstResponder:(id)sender
{
    [datePicker becomeFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    // Make a new view, or do what you want here
    [self addBlockerView];
    if(textField.tag ==3){

    // creating the picker
	ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
	// place the delegate of the picker to the controll
	picker.peoplePickerDelegate = self;

	// showing the picker
	[self presentModalViewController:picker animated:YES];
	// releasing
	[picker release];
    }else{
        return YES;
    }
    return YES;
}
#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self setDefaultValues];
    return YES;
}


- (void)changeDateInLabel:(id)sender{
	//Use NSDateFormatter to write out the date in a friendly format
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"h:mm a"];
    [df stringFromDate:datePicker.date];
	[df release];
}

- (void)backgroundClick
{
    [blockerView setEnabled:NO];
    [blockerView removeFromSuperview];
    [blockerView release];
    blockerView = nil;
    [datePicker removeFromSuperview];
    [self resignFirstResponder];
    
}


- (void)addBlockerView{
    if(blockerView == nil){
        blockerView = [[UIButton alloc] initWithFrame:[[self view] frame]];
    }
    [blockerView setBackgroundColor:[UIColor blackColor]];
    [blockerView setAlpha:0.0f];
    [blockerView addTarget:self action:@selector(backgroundClick) forControlEvents:UIControlEventTouchUpInside];
    [blockerView setEnabled:YES];
    [self.view addSubview:blockerView];
}

#pragma mark - setting default values
    //THIS MAY BE OVERKILL, BUT I WANT TO UPDATE THESE VALUES EVERY CHANCE I GET
- (void)setDefaultValues{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:description.text forKey:@"contact"];
    [defaults setObject:tname.text forKey:@"tripName"];
    [defaults setObject:tlocation.text forKey:@"tripLocation"];
}
@end
