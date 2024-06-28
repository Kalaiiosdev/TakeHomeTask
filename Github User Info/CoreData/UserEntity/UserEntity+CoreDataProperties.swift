//
//  UserEntity+CoreDataProperties.swift
//  Github User Info
//
//  Created by Ram on 26/06/24.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var avatar_url: String?
    @NSManaged public var events_url: String?
    @NSManaged public var followers_url: String?
    @NSManaged public var following_url: String?
    @NSManaged public var gists_url: String?
    @NSManaged public var gravatar_id: String?
    @NSManaged public var html_url: String?
    @NSManaged public var id: Int64
    @NSManaged public var login: String?
    @NSManaged public var node_id: String?
    @NSManaged public var organizations_url: String?
    @NSManaged public var received_events_url: String?
    @NSManaged public var repos_url: String?
    @NSManaged public var site_admin: Bool
    @NSManaged public var starred_url: String?
    @NSManaged public var subscriptions_url: String?
    @NSManaged public var type: String?
    @NSManaged public var url: String?
    @NSManaged public var isNoteAvailable: Bool

}

extension UserEntity : Identifiable {

}
