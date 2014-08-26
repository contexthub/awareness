//
//  AWNPushObjectTableViewController.m
//  Awareness
//
//  Created by Jeff Kibuule on 8/25/14.
//  Copyright (c) 2014 ChaiOne. All rights reserved.
//

#import "AWNPushObjectTableViewController.h"
#import <ContextHub/ContextHub.h>

/**
 Push event types
 */
typedef NS_ENUM(NSInteger, AWNPushEventType) {
    AWNPushEventTypeToken = 0,
    AWNPushEventTypeDeviceId,
    AWNPushEventTypeAlias,
    AWNPushEventTypeTag
};

/**
 Push mode types
 */
typedef NS_ENUM(NSInteger, AWNPushMode) {
    AWNPushModeForeground = 0,
    AWNPushModeBackground
};

@interface AWNPushObjectTableViewController ()

@property (nonatomic, weak) IBOutlet UISwitch *backgroundSwitch;

@end

@implementation AWNPushObjectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backgroundSwitch.on = NO;
}

#pragma mark - Helper Methods

- (NSString *)stringFromEventType:(AWNPushEventType)eventType {
    switch (eventType) {
        case AWNPushEventTypeToken:
            
            return @"Token";
        case AWNPushEventTypeDeviceId:
            
            return @"Device Id";
        case AWNPushEventTypeAlias:
            
            return @"Alias";
        case AWNPushEventTypeTag:
            
            return @"Tag";
        default:
            break;
    }
    
    return nil;
}

- (NSString *)stringFromPushMode:(AWNPushMode)pushMode {
    switch (pushMode) {
        case AWNPushModeForeground:
        
            return @"foreground";
        case AWNPushModeBackground:
        
            return @"background";
        default:
            break;
    }
    
    return nil;
}

#pragma mark - Table View Data Source Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSString *eventType = [NSString stringWithFormat:@"%d", row];
    AWNPushMode pushMode = self.backgroundSwitch.on ? AWNPushModeBackground : AWNPushModeForeground;
    
    // Trigger the event in ContextHub
    NSDictionary *pushEvent = @{@"name": @"push_event", @"data": @{ @"event_type": eventType, @"push_mode":[NSString stringWithFormat:@"%d", pushMode] } };
    [[CCHSensorPipeline sharedInstance] triggerEvent:pushEvent completionHandler:^(NSError *error) {
        
        if(!error) {
            NSLog(@"Successfully triggered %@ 'push_event' event type: %@", [self stringFromPushMode:pushMode], [self stringFromEventType:row]);
        } else {
            NSLog(@"Failed to trigger 'push_event' event");
            [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:@"Error triggering 'push_event' event" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        }
    }];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end