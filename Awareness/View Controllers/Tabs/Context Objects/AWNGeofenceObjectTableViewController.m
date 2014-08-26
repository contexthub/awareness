//
//  AWNGeofenceObjectTableViewController.m
//  Awareness
//
//  Created by Jeff Kibuule on 8/25/14.
//  Copyright (c) 2014 ChaiOne. All rights reserved.
//

#import "AWNGeofenceObjectTableViewController.h"
#import <ContextHub/ContextHub.h>

/**
 Geofence event types
 */
typedef NS_ENUM(NSInteger, AWNGeofenceEventType) {
    AWNGeofenceEventTypeCreate = 0,
    AWNGeofenceEventTypeTagged,
    AWNGeofenceEventTypeFind,
    AWNGeofenceEventTypeUpdate,
    AWNGeofenceEventTypeDelete
};

@interface AWNGeofenceObjectTableViewController ()

@end

@implementation AWNGeofenceObjectTableViewController

#pragma mark - Helper Methods

- (NSString *)stringFromEventType:(AWNGeofenceEventType)eventType {
    switch (eventType) {
        case AWNGeofenceEventTypeCreate:
            
            return @"Create";
        case AWNGeofenceEventTypeTagged:
            
            return @"Find by tagged";
        case AWNGeofenceEventTypeFind:
            
            return @"Find";
        case AWNGeofenceEventTypeUpdate:
            
            return @"Update";
        case AWNGeofenceEventTypeDelete:
            
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
    NSDictionary *geofenceEvent = @{@"name": @"geofence_event", @"data": @{ @"event_type": eventType } };
    [[CCHSensorPipeline sharedInstance] triggerEvent:geofenceEvent completionHandler:^(NSError *error) {
        
        if(!error) {
            NSLog(@"Successfully triggered 'geofence_event' event type: %@", [self stringFromEventType:row]);
        } else {
            NSLog(@"Failed to trigger event");
            [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:@"Error triggering 'geofence_event' event" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        }
    }];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end