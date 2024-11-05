//
//  RealmManager.swift
//  trackingapp
//
//  Created by Yazan Ahmad on 04/11/2024.
//

import RealmSwift

class RealmManager {
    // Singleton istance
    static let shared = RealmManager()

    // Realm istance
    private var realm: Realm

    // Start Realm
    private init() {
        do {
            realm = try Realm()
        } catch let error {
            fatalError("Realm can't be initialized: \(error.localizedDescription)")
        }
    }

    // Function to add a new Task to Realm
    func addTask(_ info: LocationUserModel) {
        do {
            try realm.write {
                realm.add(info)
            }
        } catch let error {
            print("Error adding task: \(error.localizedDescription)")
        }
    }
//
//    // Function to delete a Task from Realm
//    func deleteTask(_ task: Task) {
//        do {
//            // Fetch the same task from the current Realm instance
//            if let taskToDelete = realm.object(ofType: Task.self, forPrimaryKey: task.id) {
//                try realm.write {
//                    realm.delete(taskToDelete)
//                }
//            } else {
//                print("Task not found or already deleted")
//            }
//        } catch let error {
//            print("Error deleting task: \(error.localizedDescription)")
//        }
//    }
//
//    // Function to edit a Task in Realm
//    func updateTask(_ task: Task, with newTask: Task) {
//        do {
//            // Fetch the same task from the current Realm instance
//            if let taskToUpdate = realm.object(ofType: Task.self, forPrimaryKey: task.id) {
//                try realm.write {
//                    taskToUpdate.name = newTask.name
//                    taskToUpdate.type = newTask.type
//                    taskToUpdate.startTime = newTask.startTime
//                    taskToUpdate.endTime = newTask.endTime
//                }
//            } else {
//                print("No Task with id \(task.id) found")
//            }
//        } catch let error {
//            print("Error updating task: \(error.localizedDescription)")
//        }
//    }
}
