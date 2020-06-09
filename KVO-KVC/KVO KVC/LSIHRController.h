//
//  LSIHRController.h
//  KVO KVC Demo
//
//  Created by Paul Solt on 4/9/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LSIDepartment;
@class LSIEmployee;

@interface LSIHRController : NSObject

- (void)addDepartment:(LSIDepartment *)department;

// TODO: Implement the allEmployees method
- (NSArray<LSIEmployee *> *)allEmployees;


@property (nonatomic, copy, readonly) NSArray<LSIDepartment *> *departments;

@end

NS_ASSUME_NONNULL_END
