//
//  Constants.swift
//  Cricky
//
//  Created by Faiaz Rahman on 19/2/23.
//

import Foundation

class Constant {
    static let AllMatchLink = "https://cricket.sportmonks.com/api/v2.0/fixtures?api_token=8K4NjBE18zBFNZF1DzGSSFp5kdggtnyI3FqvD1rbBhEogkUsVNPMsgDuaMxR&filter[starts_between]=2015-01-0,2023-10-20&sort=-starting_at&include=stage,localteam,visitorteam,tosswon,runs.team"

    static let Key = "8K4NjBE18zBFNZF1DzGSSFp5kdggtnyI3FqvD1rbBhEogkUsVNPMsgDuaMxR"
    static let baseUrl = "https://cricket.sportmonks.com/api/v2.0"
}

func getConvertedTime(_ time: String) -> String {
    let dateString = time
    let dateStringWithOffset = dateString.replacingOccurrences(of: "Z", with: "+06:00")
    print(dateStringWithOffset)

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMM, yyyy h:mm a"
    dateFormatter.timeZone = TimeZone.current

    let utcDateString = dateStringWithOffset
    let utcDateFormatter = ISO8601DateFormatter()
    utcDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

    var localDateString = ""
    if let utcDate = utcDateFormatter.date(from: utcDateString) {
        let localDate = utcDate.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT()))
        localDateString = dateFormatter.string(from: localDate)
        // print(localDateString)
    }

    return localDateString
}

func getMonthDatesInterval(monthInterval: Int) -> String {
    let date = Date()
    let calendar = Calendar.current
    let oneMonthAgo = calendar.date(byAdding: .month, value: -monthInterval, to: date)!
    let oneMonthAfter = calendar.date(byAdding: .month, value: monthInterval, to: date)!

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"

    let oneMonthAgoString = dateFormatter.string(from: oneMonthAgo)
    let oneMonthAfterString = dateFormatter.string(from: oneMonthAfter)

    return "\(oneMonthAgoString),\(oneMonthAfterString)"
}
