//
//  AWNBeaconObjectTableViewController.m
//  Awareness
//
//  Created by Jeff Kibuule on 8/25/14.
//  Copyright (c) 2014 ChaiOne. All rights reserved.
//

#import "AWNBeaconObjectTableViewController.h"
#import <ContextHub/ContextHub.h>

/**
 Beacon rows
 */
typedef NS_ENUM(NSInteger, AWNBeaconRow) {
    AWNBeaconCreateRow = 0,
    AWNBeaconTaggedRow,
    AWNBeaconFindRow,
    AWNBeaconUpdateRow,
    AWNBeaconDeleteRow
};

/**
 Beacon event types
 */
typedef NS_ENUM(NSInteger, AWNBeaconEventType) {
    AWNBeaconEventTypeCreate = 0,
    AWNBeaconEventTypeTagged,
    AWNBeaconEventTypeFind,
    AWNBeaconEventTypeUpdate,
    AWNBeaconEventTypeDelete
};

@interface AWNBeaconObjectTableViewController ()

@end

@implementation AWNBeaconObjectTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Helper Methods

- (NSString *)stringFromEventType:(AWNBeaconEventType)eventType {
    switch (eventType) {
        case AWNBeaconEventTypeCreate:
            
            return @"Create";
        case AWNBeaconEventTypeTagged:
            
            return @"Find by tagged";
        case AWNBeaconEventTypeFind:
            
            return @"Find";
        case AWNBeaconEventTypeUpdate:
            
            return @"Update";
        case AWNBeaconEventTypeDelete:
            
            return @"Delete";
        default:
            break;
    }
}

#pragma mark - Table View Data Source Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSString *eventType =  [NSString stringWithFormat:@"%d", row];
    
    // Trigger the event in ContextHub
    NSDictionary *beaconEvent = @{@"name": @"beacon_event", @"data": @{ @"event_type": eventType } };
    [[CCHSensorPipeline sharedInstance] triggerEvent:beaconEvent completionHandler:^(NSError *error) {
        
        if(!error) {
            NSLog(@"Successfully triggered 'beacon_event' event type: %@", [self stringFromEventType:row]);
        } else {
            NSLog(@"Failed to trigger event");
            [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:@"Error triggering event" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        }
    }];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end