//
//  View+Extensions.swift
//  CoinTracker
//
//  Created by Joshua Cleetus on 1/10/22.
//

import Foundation
import SwiftUI

extension View {
    func leftAligned() -> some View {
        return self.modifier(LeftAligned())
    }
    func rightAligned() -> some View {
        return self.modifier(RightAligned())
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
