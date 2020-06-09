//
//  LSIHRDepartment.m
//  KVO KVC Demo
//
//  Created by Paul Solt on 4/9/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

#import "LSIHRController.h"
#import "LSIDepartment.h"

@interface LSIHRController ()

@property (nonatomic) NSMutableArray <LSIDepartment *> *internalDepartments;
@end


@implementation LSIHRController

- (instancetype)init {
    self = [super init];
    if (self) {
        _internalDepartments = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addDepartment:(LSIDepartment *)department {
    [self.internalDepartments addObject:department];
}

- (NSArray<LSIDepartment *> *)departments {
    return [self.internalDepartments copy];
}



- (NSString *)description {
    
    NSMutableString *output = [[NSMutableString alloc] init];
    
    [output appendString:@"Departments:\n"];
    for (LSIDepartment *department in self.departments) {
        [output appendFormat:@"%@", department];
    }
    return output;
}

- (NSArray<LSIEmployee *> *)allEmployees {
    
    NSMutableArray *employees = [NSMutableArray array];
    
    for (LSIDepartment *department in self.departments) {
        for (LSIEmployee *employee in department.employees) {
            [employees addObject:employee];
        }
    }
    return [employees copy];
}


@end
