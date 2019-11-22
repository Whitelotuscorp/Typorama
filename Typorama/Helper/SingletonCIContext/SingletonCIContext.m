//
//  SingletonCIContext.m
//  DemoCoreImage
//
//  Created by Kyle Lopez on 5/13/13.
//  Copyright (c) 2013 Kyle Lopez. All rights reserved.
//

#import "SingletonCIContext.h"

@interface SingletonCIContext ()
@property CIContext *context;
@end

@implementation SingletonCIContext

static SingletonCIContext *contextObject = nil;

+(CIContext*)context
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        contextObject = [[self alloc] init];
    });
    
    return contextObject.context;
}

-(id)init {
    if(self = [super init])
    {
        self.context = [CIContext contextWithOptions:nil];
    }
    
    return self;
}

@end