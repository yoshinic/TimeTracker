import Foundation
import TimeTrackerAPI

extension Array where Element == ActivityData {
    var toDataDic: [CategoryData: [ActivityData]] {
        self.reduce(into: [:]) { res, activity in
            if res[activity.category] == nil {
                res[activity.category] = []
            }
            res[activity.category]!.append(activity)
        }
    }
    
    var toUUIDDic: [UUID: [ActivityData]] {
        self.reduce(into: [:]) { res, activity in
            let categoryId = activity.category.id
            if res[categoryId] == nil {
                res[categoryId] = []
            }
            res[categoryId]!.append(activity)
        }
    }
}
