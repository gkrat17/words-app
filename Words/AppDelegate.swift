//
//  AppDelegate.swift
//  Words
//
//  Created by giorgi kratsashvili on 28.01.24.
//

import Data
import DI
import Domain
import Presentation
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let repo = DefaultRepo()
        do {
            try repo.load()
        } catch {
            fatalError("failed loading file")
        }

        Domain.configure(repos: .init {
            Dependency { repo as AddRepo }
            Dependency { repo as DeleteRepo }
            Dependency { repo as FavoriteRepo }
            Dependency { repo as FavoritingRepo }
            Dependency { repo as UnfavoritingRepo }
            Dependency { repo as ReadRepo }
            Dependency { repo as InfoRepo }
        })

        let event = DefaultEventUsecase()
        let favorite = DefaultFavoriteUsecase()

        let usecases = DependencyContainer {
            Dependency { DefaultAddUsecase() as AddUsecase }
            Dependency { DefaultDeleteUsecase() as DeleteUsecase }
            Dependency { DefaultReadUsecase() as ReadUsecase }
            Dependency { DefaultDetailsUsecase() as InfoUsecase }

            Dependency { event as EventUsecase }
            Dependency { event as EventSendingUsecase }
            Dependency { event as EventPublishingUsecase }

            Dependency { favorite as FavoriteUsecase }
            Dependency { favorite as FavoritingUsecase }
            Dependency { favorite as UnfavoritingUsecase }
        }

        Domain.configure(usecases: usecases)
        Presentation.configure(usecases: usecases)

        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
