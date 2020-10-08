//
//  AlarmEntity+CoreDataProperties.swift
//  WakyZzz
//
//  Created by Gabriel Balta on 07/10/2020.
//  Copyright © 2020 Olga Volkova OC. All rights reserved.
//
//

import Foundation
import CoreData


extension AlarmEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AlarmEntity> {
        return NSFetchRequest<AlarmEntity>(entityName: "AlarmEntity")
    }

    @NSManaged public var id: String
    @NSManaged public var isActive: Bool
    @NSManaged public var time: Int32
    @NSManaged public var monOn: Bool
    @NSManaged public var tueOn: Bool
    @NSManaged public var wedOn: Bool
    @NSManaged public var thuOn: Bool
    @NSManaged public var friOn: Bool
    @NSManaged public var satOn: Bool
    @NSManaged public var sunOn: Bool

}
