//
//  CSIndexable.swift.swift
//  GLapp
//
//  Created by Miguel Themann on 21.11.21.
//

import CoreSpotlight

protocol CSIndexable: Identifiable {
    
    var indexItemTitle: String { get }
    var contentDescription: String? { get }
    var rankingHint: Double? { get }
    /// Keywords to give the system about the item. Can be LocalizedStringKeys.
    var keywords: [String] { get }
    var domainIdentifier: String? { get }
    
    func makeSearchableItem() -> CSSearchableItem
}

extension CSIndexable {
    var contentDescription: String? { nil }
    var rankingHint: Double? { nil }
    var keywords: [String] { [] }
    var domainIdentifier: String? { nil }
    
    func makeSearchableItem() -> CSSearchableItem {
        let attributeSet = CSSearchableItemAttributeSet(contentType: .content)
        attributeSet.title = indexItemTitle
        attributeSet.contentDescription = contentDescription
        if let rankingHint = rankingHint {
            attributeSet.rankingHint = NSNumber(value: rankingHint)
        }
        attributeSet.keywords = keywords.map {NSLocalizedString($0)}
        let identifier: String
        if let id = id as? String {
            identifier = id
        } else {
            identifier = String(describing: id)
        }
        return .init(uniqueIdentifier: identifier, domainIdentifier: domainIdentifier, attributeSet: attributeSet)
    }
}

extension CSIndexable where Self: DeliverableByNotification {
    var contentDescription: String? { notificationSummary }
    var rankingHint: Double? { relevance }
}
