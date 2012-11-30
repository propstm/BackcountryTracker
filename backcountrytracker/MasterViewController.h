//
//  MasterViewController.h
//  backcountrytracker
//
//  Created by Matthew Propst on 11/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate, CLLocationManagerDelegate, MKMapViewDelegate>{
    CLLocationManager *locationMgr;
    float latitudef;
    float longitudef;
}

@property (nonatomic, retain) CLLocationManager *locationMgr;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, assign) float latitudef;
@property (nonatomic, assign) float longitudef;
@end
