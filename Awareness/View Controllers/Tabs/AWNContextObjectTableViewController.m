//
//  AWNContextObjectTableViewController.m
//  Awareness
//
//  Created by Jeff Kibuule on 8/25/14.
//  Copyright (c) 2014 ChaiOne. All rights reserved.
//

#import "AWNContextObjectTableViewController.h"
#import <ContextHub/ContextHub.h>

#import "AWNConstants.h"

@interface AWNContextObjectTableViewController ()

@property (nonatomic, strong) UIAlertView *alertView;

@end

@implementation AWNContextObjectTableViewController

#pragma mark - Actions

- (IBAction)eventRowTapped:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ContextHub" message:@"Trigger custom event?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag = 1;
    [alert show];
}

- (IBAction)consoleRowTapped:(id)sender {
    self.alertView = [[UIAlertView alloc] initWithTitle:@"ContextHub" message:@"Enter the message you want to log:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    self.alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    self.alertView.tag = 2;
    [self.alertView show];
}

- (IBAction)httpRowTapped:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ContextHub" message:@"Trigger http event?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag = 3;
    [alert show];
}

#pragma mark - Alert View Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (alertView.tag == 1) {
            // Trigger a custom event in ContextHub with no data
            // Fill the data dictionary with the data you want in the event
            NSDictionary *data = @{ };
            NSDictionary *customEvent = @{@"name": @"custom_event", @"data": data };
            [[CCHSensorPipeline sharedInstance] triggerEvent:customEvent completionHandler:^(NSError *error) {
                
                if(!error) {
                    NSLog(@"Successfully triggered 'custom_event' event");
                } else {
                    NSLog(@"Failed to trigger 'custom_event' event");
                    [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:@"Error triggering 'custom_event' event" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
                }
            }];
        } else if (alertView.tag == 2) {
            // Trigger the "console_event" event in ContextHub
            // Note: This is just an example of how triggering an event in ContextHub will cause a context rule to be evaluated
            // You can log messages directly from the SDK with [[CCHLog sharedInstance] log:message userInfo:nil completionHandler:nil]
            NSDictionary *consoleEvent = @{@"name": @"console_event", @"data": @{@"message": [self.alertView textFieldAtIndex:0].text } };
            [[CCHSensorPipeline sharedInstance] triggerEvent:consoleEvent completionHandler:^(NSError *error) {
                
                if(!error) {
                    NSLog(@"Successfully triggered 'console_event' event with message: %@", [self.alertView textFieldAtIndex:0].text);
                } else {
                    NSLog(@"Failed to trigger 'console_event' event");
                    [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:@"Error triggering 'console_event' event" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
                }
            }];
        } else if (alertView.tag == 3) {
            // Trigger the "http_event" event in ContextHub, which in turn will trigger the "console_event" with our custom message
            // Note: this is just an example of how to use http_event, we do not advocate creating circular rings of context events firing each other
            NSDictionary *httpEvent = @{@"name": @"http_event", @"data": @{ } };
            [[CCHSensorPipeline sharedInstance] triggerEvent:httpEvent completionHandler:^(NSError *error) {
                
                if(!error) {
                    NSLog(@"Successfully triggered 'http_event' event");
                } else {
                    NSLog(@"Failed to trigger 'http_event' event");
                    [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:@"Error triggering 'http_event' event" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
                }
            }];
        }
    }
}

@end