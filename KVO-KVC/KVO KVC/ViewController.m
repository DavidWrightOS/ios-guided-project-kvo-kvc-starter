//
//  ViewController.m
//  KVO KVC Demo
//
//  Created by Paul Solt on 4/9/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

#import "ViewController.h"
#import "LSIDepartment.h"
#import "LSIEmployee.h"
#import "LSIHRController.h"


@interface ViewController ()

@property (nonatomic) LSIHRController *hrController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    LSIDepartment *marketing = [[LSIDepartment alloc] init];
    marketing.name = @"Marketing";
    LSIEmployee * philSchiller = [[LSIEmployee alloc] init];
    philSchiller.name = @"Phil";
    philSchiller.jobTitle = @"VP of Marketing";
    philSchiller.salary = 10000000; 
    marketing.manager = philSchiller;

    
    LSIDepartment *engineering = [[LSIDepartment alloc] init];
    engineering.name = @"Engineering";
    LSIEmployee *craig = [[LSIEmployee alloc] init];
    craig.name = @"Craig";
    craig.salary = 9000000;
    craig.jobTitle = @"Head of Software";
    engineering.manager = craig;
    
    LSIEmployee *e1 = [[LSIEmployee alloc] init];
    e1.name = @"Chad";
    e1.jobTitle = @"Engineer";
    e1.salary = 200000;
    
    LSIEmployee *e2 = [[LSIEmployee alloc] init];
    e2.name = @"Lance";
    e2.jobTitle = @"Engineer";
    e2.salary = 250000;
    
    LSIEmployee *e3 = [[LSIEmployee alloc] init];
    e3.name = @"Joe";
    e3.jobTitle = @"Marketing Designer";
    e3.salary = 100000;
    
    [engineering addEmployee:e1];
    [engineering addEmployee:e2];
    [marketing addEmployee:e3];

    LSIHRController *controller = [[LSIHRController alloc] init];
    [controller addDepartment:engineering];
    [controller addDepartment:marketing];
    self.hrController = controller;
    
//    NSLog(@"%@", self.hrController);
//
    
    NSLog(@"%@", craig.name); // dot syntax: checked by compiler
    NSLog(@"%@", [craig name]); // method call: checked by compiler
    NSLog(@"%@", [craig valueForKey:@"name"]); // not checked by compiler for being a valid key path
    
    [craig setValue:@"Hair Force Craig" forKey:@"name"]; // @"nameee" crashes the app - it is not key value coding-compliant
    NSLog(@"%@", craig.name);
    
    // System will search for _likesLongWalksOnBeach and likesLongWalksOnBeach
    NSLog(@"Long walks: %@", [craig valueForKey:@"likesLongWalksOnBeach"]);
    
//    NSString *key = @"privateName";
//
//    NSString *value = [craig valueForKey:key]; // Can't use craig.privateName
//    NSLog(@"value for key %@: %@", key, value);
//
//    value = [philSchiller valueForKey:key];
//    NSLog(@"before: %@: %@", key, value);
//    [philSchiller setValue:@"Awesome Phil" forKey:key];
//    value = [philSchiller valueForKey:key];
//    NSLog(@"after: %@: %@", key, value);
    
    [engineering addEmployee:philSchiller]; // Phil is now in both departments
    
    // Command + Shift + O, search for "KeyValueOperator" to see a list of all the KVC operators
    NSString *keyPath = @"departments.@distinctUnionOfArrays.employees";
    
    NSArray *employees = [self.hrController valueForKeyPath:keyPath];
    NSLog(@"Employees: %@", employees);
    
//    NSString *key = @"salary";
//    NSArray *salaries = [employees valueForKeyPath:key];
//    NSLog(@"Salaries: %@", salaries);
    
    // (optional) check to make sure the KVC operation is successful, and handle the exception if it fails
    @try {
        NSArray *directSalaries = [self valueForKeyPath:@"hrController.departments.@unionOfArrays.employees.salary"];
        NSLog(@"Direct Salaries: %@", directSalaries);
    } @catch (NSException *exception) {
        NSLog(@"Got an exception: %@", exception);
    }
    
    [craig setValue:@"700" forKey:@"salary"];
    
    NSLog(@"Avg Salary: %@", [employees valueForKeyPath:@"@avg.salary"]);
    NSLog(@"Max Salary: %@", [employees valueForKeyPath:@"@max.salary"]);
    NSLog(@"Min Salary: %@", [employees valueForKeyPath:@"@min.salary"]);
    NSLog(@"Number of Salaries: %@", [employees valueForKeyPath:@"@count.salary"]);
    
    [engineering setValue:@"John" forKeyPath:@"manager.name"];
    [marketing setValue:@"John" forKeyPath:@"manager.name"];
    NSLog(@"New Manager's name: %@", engineering.manager.name);
    
    NSSortDescriptor *nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSSortDescriptor *salarySortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"salary" ascending:NO];
    NSArray *sortedEmployees = [employees sortedArrayUsingDescriptors:@[nameSortDescriptor,
                                                                        salarySortDescriptor]];
    NSLog(@"Sorted: %@", sortedEmployees);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", @"John"];
    NSArray *filteredEmployees = [employees filteredArrayUsingPredicate:predicate];
    NSLog(@"Filtered: %@", filteredEmployees);

}

@end
