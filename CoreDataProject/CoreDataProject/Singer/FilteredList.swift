//
//  FilteredSingerList.swift
//  CoreDataProject
//
//  Created by Bogdan Orzea on 2022-10-10.
//

import CoreData
import SwiftUI

enum PredicateOperation: String {
    case like = "LIKE"
    case contains = "CONTAINS"
    case beginsWith = "BEGINSWITH"
    case beginWithCaseInsensitive = "BEGINSWITH[c]"
    case endsWith = "ENDSWITH"
    case endsWithCaseInsensitive = "ENDSWITH[c]"
}


struct FilteredList<T: NSManagedObject, Content: View>: View {
    @FetchRequest var fetchRequest: FetchedResults<T>
    let content: (T) -> Content
    
    var body: some View {
        List {
            ForEach(fetchRequest, id: \.self) { item in
                content(item)
            }
        }
    }
    
    init(filterKey: String,
         filterOperation: PredicateOperation,
         filterValue: String,
         sortDescriptors: [SortDescriptor<T>],
         @ViewBuilder content: @escaping (T) -> Content
    ) {
        let formatString = "%K " + filterOperation.rawValue + " %@"
        _fetchRequest = FetchRequest<T>(sortDescriptors: sortDescriptors, predicate: NSPredicate(format: formatString, filterKey, filterValue))
        self.content = content
    }
}

