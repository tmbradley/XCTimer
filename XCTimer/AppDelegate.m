//
//  AppDelegate.m
//  XCTimer
//
//  Created by MBradley on 12/7/12.
//  Copyright (c) 2012 MBradley. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <Dropbox/Dropbox.h>
#import "MenuController.h"
#import "Event+Methods.h"
#import "EventTime.h"
#import "Person+Methods.h"
#import "Note.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"GSJuyT4GD5Ykn6rFJl0zufL5tsq4GF22t14FHOg6"
                  clientKey:@"eDadJ36FF6k8ECR9MyXZvk1bxP57UvpR5HrDa9vr"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
//    DBAccountManager* accountManager = [[DBAccountManager alloc] initWithAppKey:@"jxg7m500etetvjo" secret:@"w3r14wyo4gpjkmg"];
//    [DBAccountManager setSharedManager:accountManager];
    
    MenuController *menu = [[MenuController alloc] init];
    menu.managedObjectContext = [self managedObjectContext];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:menu];
    navController.navigationBar.tintColor = [UIColor blackColor];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
//    self.window.backgroundColor = [UIColor whiteColor];
    
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
//    [self createEvents];
    [self createRoster];
    return YES;
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url
//  sourceApplication:(NSString *)source annotation:(id)annotation
//{
//    DBAccount *account = [[DBAccountManager sharedManager] handleOpenURL:url];
//    if (account)
//    {
//        NSLog(@"App linked successfully!");
//        return YES;
//    }
//    return NO;
//}
-(void)createEvents
{
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetch error:nil];
    if (!results || [results count]==0)
    {
        NSArray *events = [NSArray arrayWithObjects:@"100m",@"100m Hurdle",@"110m Hurdle",@"200m",@"400m",@"400m Relay",@"400m Hurdle",@"800m",@"1600m",@"1600m Relay",@"3200m",@"3200m Relay",@"5k",nil];
        for(NSString *eventName in events)
        {
            Event *event = (Event*)[NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
            event.name= eventName;
            if(![self.managedObjectContext save:NULL])
            {
                NSLog(@"ERROR");
            }
        }
    }
    
    NSArray *results2 = [self.managedObjectContext executeFetchRequest:fetch error:nil];
    NSLog(@"Event Size: %i",[results2 count]);
}
-(void)createRoster
{
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetch error:nil];
    if (!results || [results count]==0)
    {
        NSArray *peopleFirstName = [NSArray arrayWithObjects:@"Zach",@"Daniel",@"James",@"Josh",@"Mark",@"Michael",@"Adam",@"Jacob",@"Nathan",@"Avery",@"Nicholas",@"Ammar",@"Evan",@"Josh",@"Jacob",@"Adam",@"Alex",@"Chris",@"Jackson",@"Jo",@"Max",@"Christian",@"Jackson",@"Hunter",@"Jacob",@"Chris",@"Michaeal",@"Khaleel",@"Andrew",@"Mark",@"David",@"Matthew",@"Michael",@"Jonah",@"Kai",@"Ryan",@"Chris",@"Tim",@"Hayden",@"Josheph",@"Gray",@"Austin",@"Lindsey",@"Nicholas",@"Alex",@"Micah",nil];
        NSArray *peopleLastName = [NSArray arrayWithObjects:@"Atkins",@"Bass",@"Bowen",@"Boyd",@"Bradley",@"Bradley",@"Brown",@"Crawford",@"Demi",@"Dominick",@"Dorman",@"Dossaji",@"Fish",@"Frankle",@"Gibson",@"Greene",@"Hartley",@"Jamison",@"Jordan",@"Klasnic",@"Land",@"McGlaughlin",@"McGregor",@"McIntosh",@"Murphy",@"Myers-Davis",@"Naso",@"Peterson",@"Porter",@"Porter",@"Privette",@"Quindlen",@"Raab",@"Rothholz",@"Schuster",@"Short",@"Stafford",@"Stafford",@"Stansbury",@"Topinka",@"Ward",@"Weitz",@"Wilson",@"Woodall",@"Wyatt",@"Zahn",nil];
        for (int i = 0; i<[peopleFirstName count]; i++)
        {
            Person *person = (Person*)[NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
            NSString *firstName = [peopleFirstName objectAtIndex:i];
            NSString *lastName = [peopleLastName objectAtIndex:i];
            NSString  *uuid = [[NSUUID UUID] UUIDString];
            person.firstName =firstName;
            person.lastName = lastName;
            person.id = uuid;
            if(![self.managedObjectContext save:NULL])
            {
                NSLog(@"ERROR");
            }
                
            PFObject *onlinePerson = [PFObject objectWithClassName:@"Person"];
            [onlinePerson setObject:person.firstName forKey:@"firstName"];
            [onlinePerson setObject:person.lastName forKey:@"lastName"];
            [onlinePerson setObject:person.id forKey:@"id"];
            [onlinePerson saveInBackground];
            
        }
//        for(NSString *personFirstName in peopleFirstName)
//        {
//            if(![self.managedObjectContext save:NULL])
//            {
//                NSLog(@"ERROR");
//            }
//        }
//        for(NSString *personLastName in peopleLastName)
//        {
//            if(![self.managedObjectContext save:NULL])
//            {
//                NSLog(@"ERROR");
//            }
//        }
    }

    NSArray *results2 = [self.managedObjectContext executeFetchRequest:fetch error:nil];
    NSLog(@"Roster Size: %i",[results2 count]);
}
//-(void)savePeople
//{
//    PFQuery *query = [PFQuery queryWithClassName:@"Person"];
//    [query getObjectInBackgroundWithId:@"xWMyZ4YEGZ" block:^(PFObject *person, NSError *error)
//     {
//        
//        NSLog(@"%@",person);
//    }];
//}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"XCTimer" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"XCTimer.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:@{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES} error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
