//
//  AppDelegate.swift
//  VirtualTourist
//
//  Created by Alex Pendleton on 10/29/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
public class AppDelegate: UIResponder, UIApplicationDelegate {

    public var window: UIWindow?
    public var dataFiller: InitialDataFiller!
    public var stackManager: CoreDataStackManager!
    
    public var appConfigRepo: NsmAppConfigurationRepository!
    public var appConfigFactory: NsmAppConfigurationFactory!
    
    //public var appConfigManager: AppConfigManager!
    
    public static func sharedInstance() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }

    public func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        stackManager = CoreDataStackManager()
        
        let context = stackManager.managedObjectContext
        appConfigRepo = NsmAppConfigurationRepository(context: context)
        appConfigFactory = NsmAppConfigurationFactory(context: context)
        dataFiller = InitialDataFiller(context: context, factory: appConfigFactory, repository: appConfigRepo)
        try! dataFiller.fillIfNecessary()
        
        
        var appConfigManager = AppConfigManager(repo: appConfigRepo, factory: appConfigFactory)
        let fu = try! appConfigRepo.only()
        appConfigManager.record = fu
        AppConfigManager.sharedInstance = appConfigManager
        // Override point for customization after application launch.
        return true
    }

    public func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    public func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    public func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    public func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    public func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        try! self.stackManager.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.alexcpendleton.VirtualTourist" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()


}

