//
//  NetworkController.h
//  Autoloop
//
//  Created by Josh Billions on 2/1/15.
//  Copyright (c) 2015 Catalyze Chicago. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkController : NSObject

+(NetworkController *)sharedInstance;

-(void)sendMessage:(NSString *)message;

@end
