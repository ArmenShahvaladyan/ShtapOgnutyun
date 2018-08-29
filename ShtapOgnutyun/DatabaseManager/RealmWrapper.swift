                                                                                                                                                          //
//  RealmWrapper.swift
//  ShtapOgnutyun
//
//  Created by My Mac on 5/29/18.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import Foundation
import RealmSwift

let uiRealm = try! Realm()

class RealmWrapper {
    
    class var sharedInstance: RealmWrapper {
        struct Singleton {
            static let instance = RealmWrapper()
        }
        return Singleton.instance
    }
    
    //    func configureRealmMigration()  {
    //
    //        Realm.Configuration.defaultConfiguration = Realm.Configuration (
    //            schemaVersion: 1,
    //            migrationBlock: { migration, oldSchemaVersion in
    //                migration.enumerateObjects(ofType: User.className()) { oldObject, newObject in
    //
    //                    if oldSchemaVersion < 1 {
    //                        newObject?["timezone"] = Utils.localTimeZoneName
    //                    }
    //                }
    //        })
    //    }
    
    func getObjectFromTable(fiter f:String, objectType:Object.Type) -> Results<Object> {
        let obj = uiRealm.objects(objectType).filter(f)
        return obj
    }
    
    func getObjectFromTable(withPrimaryKey pk:String, objectType:Object.Type ) -> Object {
        var returnObject = Object.init()
        
        let obj = uiRealm.object(ofType: objectType, forPrimaryKey: pk)
        
        if obj != nil {
            returnObject = obj!
        }
        
        return returnObject
    }
    
    func getAllObjectsOfModelFromRealmDB(_ objectType:Object.Type) -> [Object] {
        var returnObjects = [Object]()
        
        let objects = uiRealm.objects(objectType)
        
        for object in objects {
            returnObjects.append(object)
        }
        return returnObjects
    }
    
    func addObjectInRealmDB(_ object: Object, update: Bool = false ) {
        do {
            try uiRealm.write({
                uiRealm.add(object, update: update)
            })
        } catch {
            debugPrint("Something went wrong!")
        }
    }
    
    func updateObjectsWithPrinaryKey(completation : () -> Void) {
        do {
            try uiRealm.write({
                completation()
            })
        } catch {
            debugPrint("Something went wrong!")
        }
    }
    
    func deleteObjectFromRealmDB(_ object: Object)  {
        do {
            try uiRealm.write({
                uiRealm.delete(object)
            })
        } catch {
            debugPrint("Something went wrong!")
        }
    }
    
    func deleteObjectsOfModelInRealmDB(_ objectType:Object.Type) {
        let objects = uiRealm.objects(objectType)
        if objects.count == 0 {
            return
        }
        do {
            try uiRealm.write({
                uiRealm.delete(objects)
            })
        } catch {
            debugPrint("Something went wrong!")
        }
    }
    
    func deleteAllFromDB(complation:()->Void )  {
        do {
            try uiRealm.write({
                uiRealm.deleteAll()
                complation()
            })
        } catch {
            debugPrint("Something went wrong!")
        }
    }
    
}

