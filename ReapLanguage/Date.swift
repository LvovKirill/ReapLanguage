import CoreData
import Foundation

class DateManager{
    
    static func getCurrentDate() -> DateComponents{
        let currentDateTime = Date()
        let userCalendar = Calendar.current
        let requestedComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day,
            .hour,
            .minute,
            .second
        ]
        return userCalendar.dateComponents(requestedComponents, from: currentDateTime)
    }
    
    static func getModifiedByHourDate(hour: Int) -> Date{
        let userCalendar = Calendar.current
        let dateTimeComponents = getCurrentDate()
        var dateComponents = DateComponents()
        dateComponents.year = dateTimeComponents.year
        dateComponents.month = dateTimeComponents.month
        dateComponents.day = dateTimeComponents.day
        dateComponents.hour = dateTimeComponents.hour! + hour
        dateComponents.minute = dateTimeComponents.minute
        return userCalendar.date(from: dateComponents)!
    }
    
    static func getDateComponents(date: Date) -> DateComponents{
        let userCalendar = Calendar.current
        let requestedComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day,
            .hour,
            .minute,
            .second
        ]
        return userCalendar.dateComponents(requestedComponents, from: date)
    }
    
    static func getDate(dateComponents: DateComponents) -> Date{
        let userCalendar = Calendar.current
        return userCalendar.date(from: dateComponents)!
    }
    
}
