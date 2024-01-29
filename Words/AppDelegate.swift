//
//  AppDelegate.swift
//  Words
//
//  Created by giorgi kratsashvili on 28.01.24.
//

import Domain
import Presentation
import Data
import DI
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let repo = Repo()
        Domain.configure(repos: .init {
            Dependency { repo as AddRepo }
            Dependency { repo as DeleteRepo }
            Dependency { repo as FavoriteRepo }
            Dependency { repo as ReadRepo }
            Dependency { repo as InfoRepo }
        })
        let usecases = DependencyContainer {
            Dependency { DefaultAddUsecase() as AddUsecase }
            Dependency { DefaultDeleteUsecase() as DeleteUsecase }
            Dependency { DefaultEventUsecase() as EventUsecase }
            Dependency { DefaultFavoriteUsecase() as FavoriteUsecase }
            Dependency { DefaultReadUsecase() as ReadUsecase }
            Dependency { DefaultDetailsUsecase() as InfoUsecase }
        }
        Domain.configure(usecases: usecases)
        Presentation.configure(usecases: usecases)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

