//
//  StorageService + Dependent.swift
//  BCVaccineCard
//
//  Created by Amir Shayegh on 2022-11-01.
//

import Foundation

extension StorageService {
    
    func store(dependents: [RemoteDependent], for patient: Patient, completion: @escaping([Dependent])->Void) {
        var storedDependends: [Dependent] = []
        for dependent in dependents {
            
            if let info = dependent.dependentInformation,
               let versionInt = dependent.version,
               let reasonCodeInt = dependent.reasonCode
            {
                let firstName = info.firstname ?? ""
                let lastName = info.lastname ?? ""
                
                if let storedPatient = storePatient(
                    name: firstName + " " + lastName,
                    firstName: firstName,
                    lastName: lastName,
                    gender: info.gender,
                    birthday: info.dateOfBirth?.getGatewayDate(),
                    phn: info.phn,
                    hdid: info.hdid,
                    authenticated: false) {
                    if let storedDependent = storeDependent(ownerID: dependent.ownerID,
                                                            delegateID: dependent.delegateID,
                                                            version: Int64(versionInt),
                                                            reasonCode: Int64(reasonCodeInt),
                                                            info: storedPatient)
                    {
                        storedDependends.append(storedDependent)
                    }
                }
            }
        }
        add(dependents: storedDependends, to: patient)
        return completion(storedDependends)
    }
    
    func storeDependent(
        ownerID: String?,
        delegateID: String?,
        version: Int64,
        reasonCode: Int64,
        info: Patient
    ) -> Dependent? {
        guard let context = managedContext else {return nil}
        let dependent = Dependent(context: context)
        dependent.ownerID = ownerID
        dependent.delegateID = delegateID
        dependent.version = version
        dependent.reasonCode = reasonCode
        dependent.info = info
        do {
            try context.save()
            notify(event: StorageEvent(event: .Save, entity: .Dependent, object: dependent))
            return dependent
        } catch let error as NSError {
            // TODO: Amir - noticed a bug here
            // Steps:
            // 1: Login from dependent tab with user 11
            // 2: You'll notice that is appears user 11 doesn't have any dependents (they do)
            // 3: Killing the app and relaunching it, after the background synch, dependents will appear
            // 4: If you re-do these steps from 1, except log in from another screen (say home screen), there is no issue. However, when logging in from dependents tab, we get this error here (put breakpoint on line 72 and you'll see)
            // Note: This is also the cause of bug 1357
            Logger.log(string: "Could not save. \(error), \(error.userInfo)", type: .storage)
            return nil
        }
    }
    
    func add(dependents: [Dependent], to patient: Patient) {
        for dependent in dependents {
            addDependent(dependent: dependent, to: patient)
        }
    }
    
    func addDependent(dependent: Dependent, to patient: Patient) {
        guard let context = managedContext else {return}
        patient.addToDependents(dependent)
        do {
            try context.save()
        } catch let error as NSError {
            Logger.log(string: "Could not save. \(error), \(error.userInfo)", type: .storage)
            return
        }
    }
    
    func deleteDependents(for patient: Patient) {
        guard let context = managedContext else {return}
        guard let dependents = patient.dependents else {return}
        let dependentsArray = patient.dependentsArray
        patient.removeFromDependents(dependents)
        dependentsArray.forEach({delete(object: $0)})
        do {
            try context.save()
        } catch let error as NSError {
            Logger.log(string: "Could not save. \(error), \(error.userInfo)", type: .storage)
            return
        }
    }
    
    func delete(dependents: [Dependent], for patient: Patient) {
        guard let context = managedContext else {return}
        dependents.forEach({patient.removeFromDependents($0)})
        dependents.forEach({delete(object: $0)})
        do {
            try context.save()
        } catch let error as NSError {
            Logger.log(string: "Could not save. \(error), \(error.userInfo)", type: .storage)
            return
        }
    }
}
