//
//  AppDelegate.swift
//  YES33
//
//  Created by JIN LEE on 5/12/25.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    // MARK: - Core Data stack

       // NSPersistentContainer를 지연 저장 프로퍼티(lazy var)로 선언합니다.
       // 앱에서 처음 코어 데이터에 접근할 때 초기화됩니다.
       lazy var persistentContainer: NSPersistentContainer = {
           /*
            The persistent container for the application. This implementation
            creates and returns a container, having loaded the store for the
            application to it. This property is optional since there are legitimate
            error conditions that could cause the creation of the store to fail.
           */
           // "YourDataModelName"을 실제 .xcdatamodeld 파일의 이름으로 변경해야 합니다.
           let container = NSPersistentContainer(name: "Books")
           
           // 영구 저장소를 로드합니다. 비동기적으로 처리될 수 있습니다.
           container.loadPersistentStores(completionHandler: { (storeDescription, error) in
               if let error = error as NSError? {
                   // 실제 앱에서는 fatalError 대신 적절한 에러 처리를 해야 합니다.
                   // 예: 사용자에게 알림, 로그 기록 등
                   // fatalError()는 개발 중에는 유용하지만, 배포용 앱에서는 사용하지 않아야 합니다.
                   fatalError("Unresolved error \(error), \(error.userInfo)")
               }
               // (선택 사항) Merge Policy 설정 등 추가 설정이 필요하면 여기에 작성 [2]
               // 예: container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
               // 예: container.viewContext.automaticallyMergesChangesFromParent = true // 백그라운드 컨텍스트 변경 사항 자동 병합
           })
           return container
       }() // 클로저 실행 결과를 persistentContainer에 할당

       // MARK: - Core Data Saving support

       // NSManagedObjectContext의 변경사항을 저장하는 헬퍼 함수입니다.
       func saveContext () {
           let context = persistentContainer.viewContext // 메인 스레드에서 사용하는 컨텍스트
           if context.hasChanges { // 변경사항이 있을 때만 저장 시도
               do {
                   try context.save() // 변경사항 저장
               } catch {
                   // 실제 앱에서는 fatalError 대신 적절한 에러 처리를 해야 합니다.
                   let nserror = error as NSError
                   fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
               }
           }
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

