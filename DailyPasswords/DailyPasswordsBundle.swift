//
//  DailyPasswordsBundle.swift
//  DailyPasswords
//
//  Created by Михаил Митрованов on 22.06.2025.
//

import WidgetKit
import SwiftUI

@main
struct DailyPasswordsBundle: WidgetBundle {
    var body: some Widget {
        DailyPasswords()
        DailyPasswordsControl()
    }
}
