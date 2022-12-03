//
//  PersonRepository.swift
//  Mogakko
//
//  Created by 소연 on 2022/12/02.
//

import Foundation

import RealmSwift

protocol PersonRepositoryType {
    func addPersonItem(person: Person)
    func fetchPerson() -> Results<Person>
}

final class PersonRepository: PersonRepositoryType {
    
    let localRealm = try! Realm()
    
    func addPersonItem(person: Person) {
        do {
            try localRealm.write {
                localRealm.add(person)
            }
        } catch let error {
            print(error)
        }
    }
    
    func fetchPerson() -> Results<Person> {
        return localRealm.objects(Person.self).sorted(byKeyPath: "uid", ascending: false)
    }
    
    func filterPerson(uid: String) -> Results<Person> {
        return localRealm.objects(Person.self).where {
            ($0.uid == uid)
        }
    }
}
