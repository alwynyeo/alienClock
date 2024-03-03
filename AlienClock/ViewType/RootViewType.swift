//
//  RootViewType.swift
//  AlienClock
//
//  Created by Alwyn Yeo on 3/5/24.
//


// MARK: - Protocol
protocol RootViewType: AnyObject {
    func updateAlienDateTimeLabel(dateString: String)
    func updateEarthDateTimeLabel(dateString: String)
    func clearTextFields()
}
