//
//  CheckFunctions.swift
//  Park Sharing
//
//  Created by Silviu Nicolae on 04.11.2021.
//

import Foundation
import SwiftUI

// MARK: - For Saving Data
// 1 - nimic
// 2 - Loading
// 3 - Succes
// 4 - Error
struct SaveTextView: View {
    @Binding var number: Int
    var body: some View {
        if number == 1 {
            Text(LocalizedStringKey("BtnSave"))
                .foregroundColor(.white)
        } else if number == 2 {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
        } else if number == 3 {
            Text(LocalizedStringKey("SuccesTitle"))
                .foregroundColor(.white)
        } else if number == 4 {
            Text(LocalizedStringKey("ErrorTitle"))
                .foregroundColor(.red)
        }
    }
}


// MARK: - Check if string is only numbers
extension String {
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
}
