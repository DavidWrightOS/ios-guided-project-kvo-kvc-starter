//
//  LSIEmployee.m
//  KVO KVC Demo
//
//  Created by Paul Solt on 4/9/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

#import "LSIEmployee.h"

// MARK: Class extension

@interface LSIEmployee () {
    BOOL _likesLongWalksOnBeach;
}

@property (nonatomic, copy) NSString *privateName;

@end


// MARK: Class implementation

@implementation LSIEmployee

- (instancetype)init
{
    if (self = [super init]) {
        _privateName = @"Hair Force One";
    }
    return self;
}

- (NSString *)description {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle; // $ (current Locale)
    formatter.allowsFloats = NO;
//    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"de"];
    formatter.usesGroupingSeparator = YES; //3,000
    
    // These are equivalent:
    // [NSNumber numberWithInteger:self.salary];
    // @(self.salary);
    NSString *salaryString = [formatter stringFromNumber:@(self.salary)]; // NSInteger (primitive) -> NSNumber (object)
    return [NSString stringWithFormat:@"%@, Title: %@, Salary: %@", self.name, self.jobTitle, salaryString];
}

@end
