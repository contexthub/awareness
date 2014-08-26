//
//  AWNVaultObjectTableViewController.m
//  Awareness
//
//  Created by Jeff Kibuule on 8/25/14.
//  Copyright (c) 2014 ChaiOne. All rights reserved.
//

#import "AWNVaultObjectTableViewController.h"
#import <ContextHub/ContextHub.h>

/**
 Vault event types
 */
typedef NS_ENUM(NSInteger, AWNVaultEventType) {
    AWNVaultEventTypeCreate = 0,
    AWNVaultEventTypeTagged,
    AWNVaultEventTypeFind,
    AWNVaultEventTypeUpdate,
    AWNVaultEventTypeDelete,
    AWNVaultEventTypeContains,
    AWNVaultEventTypeKeyPath
};

@interface AWNVaultObjectTableViewController ()

@end

@implementation AWNVaultObjectTableViewController

#pragma mark - Helper Methods

- (NSString *)stringFromEventType:(AWNVaultEventType)eventType {
    switch (eventType) {
        case AWNVaultEventTypeCreate:
            
            return @"Create";
        case AWNVaultEventTypeTagged:
            
            return @"Find by tagged";
        case AWNVaultEventTypeFind:
            
            return @"Find";
        case AWNVaultEventTypeUpdate:
            
            return @"Update";
        case AWNVaultEventTypeDelete:
            
            return @"Delete";
        case AWNVaultEventTypeContains:
            
            return @"Contains";
        case AWNVaultEventTypeKeyPath:
            
            return @"Key path";
        default:
            break;
    }
}

#pragma mark - Table View Data Source Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSString *eventType =  [NSString stringWithFormat:@"%d", row];
    
    // Trigger the event in ContextHub
    NSDictionary *vaultEvent = @{@"name": @"vault_event", @"data": @{ @"event_type": eventType } };
    [[CCHSensorPipeline sharedInstance] triggerEvent:vaultEvent completionHandler:^(NSError *error) {
        
        if(!error) {
            NSLog(@"Successfully triggered 'vault_event' event type: %@", [self stringFromEventType:row]);
        } else {
            NSLog(@"Failed to trigger event");
            [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:@"Error triggering 'vault_event' event" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        }
    }];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end