//
//  RootViewModel.swift
//  AlienClock
//
//  Created by Alwyn Yeo on 3/5/24.
//

import Foundation

final class RootViewModel {
    // Private State
    private weak var view: RootViewType?

    private let alienSecond: Int = 90
    private let alienMinute: Int = 90
    private let alienHour: Int = 36
    private let alienMonth: Int = 18

    private let monthDays: [Int: Int] = [
        1: 44,
        2: 42,
        3: 48,
        6: 44,
        7: 40,
        8: 44,
        9: 42,
        10: 40,
        11: 40,
        12: 42,
        13: 44,
        14: 48,
        15: 42,
        16: 40,
        17: 44,
        18: 38,
    ]

    // Create a DateFormatter object
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter
    }()

    init(view delegate: RootViewType) {
        self.view = delegate
    }

    func startTimeConversion(from earthTime: Date) {
        let alienTime = getConvertedAlienTime(from: earthTime)
        let alienTimeString = getFormattedAlienTime(alienTime: alienTime)
        view?.updateAlienDateTimeLabel(dateString: alienTimeString)

        let earthTime = getConvertedEarthTime(from: alienTime)
        let earthTimeString = dateFormatter.string(from: earthTime)

        view?.updateEarthDateTimeLabel(dateString: earthTimeString)
    }

    func resetTimer() {
        let earthDate = Date(timeIntervalSince1970: .zero)
       startTimeConversion(from: earthDate)
        view?.clearTextFields()
    }

    func handleSetEarthDateTimeButton(newDateString: String?) {
        guard let newDateString = newDateString else {
            return
        }
        let components = newDateString.components(separatedBy: .whitespaces)
        let year = Int(components[0]) ?? .zero
        let month = Int(components[1]) ?? .zero
        let day = Int(components[2]) ?? .zero
        let hour = Int(components[3]) ?? .zero
        let minute = Int(components[4]) ?? .zero
        let second = Int(components[5]) ?? .zero

        let earthTimeString = "\(year)-\(month)-\(day) \(hour):\(minute):\(second)"

        guard let earthTime = dateFormatter.date(from: earthTimeString) else {
            return
        }

        let alienTime = getConvertedAlienTime(from: earthTime)
        let alienTimeString = getFormattedAlienTime(alienTime: alienTime)
        view?.updateAlienDateTimeLabel(dateString: alienTimeString)
        view?.updateEarthDateTimeLabel(dateString: earthTimeString)
    }

    // MARK: - Helper Functions
    private func getConvertedEarthTime(from alienTime: AlienTime) -> Date {
        let earthTimeSinceEpoch = Double(alienTime.second) / 2

        // Convert seconds since epoch to a Date object
        let earthTime = Date(timeIntervalSince1970: earthTimeSinceEpoch)

        return earthTime
    }

    private func getConvertedAlienTime(from earthTime: Date) -> AlienTime {
        let alienTime = alienTimeSinceEpoch()
        let earthTimeSinceEpoch = Int(earthTime.timeIntervalSince1970 * 2)

        let newAlienTime = tick(alienTime: alienTime, duration: earthTimeSinceEpoch)

        return newAlienTime
    }

    private func alienTimeSinceEpoch() -> AlienTime {
        let alienTime = AlienTime(
            year: 2804,
            month: 18,
            day: 31,
            hour: 2,
            minute: 2,
            second: 88
        )

        return alienTime
    }

    // Non Optimized
    private func tick(alienTime: AlienTime, duration: Int) -> AlienTime {
        var newAlienTime = alienTime
        newAlienTime.second += duration

        while newAlienTime.second >= alienSecond {
            newAlienTime.second -= alienSecond
            newAlienTime.minute += 1

            if newAlienTime.minute >= alienMinute {
                newAlienTime.minute -= alienMinute
                newAlienTime.hour += 1
            }

            if newAlienTime.hour >= alienHour {
                newAlienTime.hour -= alienHour
                newAlienTime.day += 1
            }

            let day = monthDays[newAlienTime.month] ?? .zero

            if newAlienTime.day > day {
                newAlienTime.day -= monthDays[newAlienTime.month] ?? .zero
                newAlienTime.month += 1
            }

            if newAlienTime.month > alienMonth {
                newAlienTime.month = 1
                newAlienTime.year += 1
            }
        }

        return newAlienTime
    }

    private func getFormattedAlienTime(alienTime: AlienTime) -> String {
        let year = String(format: "%02d", alienTime.year)
        let month = String(format: "%02d", alienTime.month)
        let day = String(format: "%02d", alienTime.day)
        let hour = String(format: "%02d", alienTime.hour)
        let minute = String(format: "%02d", alienTime.minute)
        let second = String(format: "%02d", alienTime.second)

        let alienTimeString = "\(year)-\(month)-\(day) \(hour):\(minute):\(second)"
        return alienTimeString
    }
}
