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

- (IBAction)consoleRowTapped:(id)sender {
    self.alertView = [[UIAlertView alloc] initWithTitle:@"ContextHub" message:@"Enter the message you want to log:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    self.alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [self.alertView show];
}

#pragma mark - Alert View Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        // Trigger the event in ContextHub
        // Note: This is just an example of how triggering an event in ContextHub will cause a context rule to be evaluated
        // You can log messages directly from the SDK with [[CCHLog sharedInstance] log:message userInfo:nil completionHandler:nil]
        NSDictionary *consoleEvent = @{@"name": @"console_event", @"data": @{@"message": [self.alertView textFieldAtIndex:0].text } };
        [[CCHSensorPipeline sharedInstance] triggerEvent:consoleEvent completionHandler:^(NSError *error) {
            
            if(!error) {
                NSLog(@"Successfully triggered 'console_event' event type: Log");
            } else {
                NSLog(@"Failed to trigger event");
                [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:@"Error triggering event" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
            }
        }];
    }
}

@end