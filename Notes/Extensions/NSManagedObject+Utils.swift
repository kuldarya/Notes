//
//  NSManagedObject+Utils.swift
//  Notes
//
//  Created by Darya Kuliashova on 12/10/19.
//  Copyright © 2019 Darya Kuliashova. All rights reserved.
//

import CoreData

extension NSManagedObject {
    convenience init?(managedObjectContext: NSManagedObjectContext) {
        let entityName = NoteEntity.className
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext) else {
            return nil
        }
        self.init(entity: entity, insertInto: managedObjectContext)
    }
}
