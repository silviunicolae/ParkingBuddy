//
//  Park_SharingApp.swift
//  Park Sharing
//
//  Created by Silviu Nicolae on 11.10.2021.
//

import SwiftUI
import Parse

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // MARK: - PARSE
        let configuration = ParseClientConfiguration {
          $0.applicationId = app_applicationId
          $0.clientKey = app_clientKey
          $0.server = app_server
        }
        Parse.initialize(with: configuration)
        saveInstallationObject()
        
        return true
    }
    
    func saveInstallationObject(){
        if let installation = PFInstallation.current(){
            installation.saveInBackground {
                (success: Bool, error: Error?) in
                if (success) {
                    print("succes")
                } else {
                    if let myError = error{
                        print("pag Park")
                        print(myError.localizedDescription)
                    }else{
                        print("pag Park - Uknown error")
                    }
                }
            }
        }
    }
}

@main
struct Park_SharingApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
