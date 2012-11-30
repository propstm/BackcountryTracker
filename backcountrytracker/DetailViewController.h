//
//  DetailViewController.h
//  backcountrytracker
//
//  Created by Matthew Propst on 11/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface DetailViewController : UIViewController<ABPeoplePickerNavigationControllerDelegate, UITextFieldDelegate>
{
    UITextField *tname;
    UITextField *tlocation;
    UITextField *description;
    UILabel *contactName;
    UIDatePicker *datePicker;
    UIButton *blockerView;
}

@property (nonatomic, retain) IBOutlet UITextField *tname;
@property (nonatomic, retain) IBOutlet UITextField *tlocation;
@property (nonatomic, retain) IBOutlet UITextField *description;
@property (nonatomic, retain) IBOutlet UILabel *contactName;
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;


@end
