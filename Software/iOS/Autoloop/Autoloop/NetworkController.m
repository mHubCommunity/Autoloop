//
//  NetworkController.m
//  Autoloop
//
//  Created by Josh Billions on 2/1/15.
//  Copyright (c) 2015 Catalyze Chicago. All rights reserved.
//

#import "NetworkController.h"
#import "GCDAsyncUdpSocket.h"

@interface NetworkController()

@property (nonatomic, strong) GCDAsyncUdpSocket *udpSocket;

@end

@implementation NetworkController

static NetworkController *sharedInstance = nil;

+ (NetworkController *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NetworkController alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        NSError *bindError = nil;
        if (![self.udpSocket bindToPort:6667 error:&bindError]) {
            NSLog(@"Error binding: %@", bindError);
        }
        NSLog(@"UDP Socket Ready");
    }
    return self;
}

-(void)sendMessage:(NSString *)message{
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    [self.udpSocket sendData:data toHost:@"192.168.3.10" port:8888 withTimeout:5 tag:-1];
}

@end
