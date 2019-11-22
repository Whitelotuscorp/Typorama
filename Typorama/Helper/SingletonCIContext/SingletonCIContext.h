//
//  SingletonCIContext.h
//  DemoCoreImage
//
//  Created by Kyle Lopez on 5/13/13.
//  Copyright (c) 2013 Kyle Lopez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreImage/CoreImage.h>

@interface SingletonCIContext : NSObject
+(CIContext*)context;
@end
