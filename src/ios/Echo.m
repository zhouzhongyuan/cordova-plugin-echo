#import "Echo.h"
#import <Cordova/CDVPlugin.h>


#import <Availability.h>
#import "FirstController.h"
#import "RootNavigationController.h"
#import "JudgeCustomerOptional.h"

@implementation Echo
- (void)echo: (CDVInvokedUrlCommand *) command;
{
    //CDVPluginResult *pluginResult = nil;
    //NSString *echo = [command.arguments objectAtIndex:0];
    //if(echo != nil && [echo length] > 0 ){
    //    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo ];
    //}else{
    //    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    //}
    //[self.commandDelegate sendPluginResult: pluginResult callbackId: command.callbackId];


    FirstController *controller = [[FirstController alloc]init];
    RootNavigationController *naviVC=[[RootNavigationController alloc]initWithRootViewController:controller];
    naviVC.navigationBar.translucent = NO;
    [naviVC.navigationBar setBarTintColor:APPMAINCOLOR];
    [self.viewController presentViewController:naviVC animated:YES completion:nil];



}
@end
