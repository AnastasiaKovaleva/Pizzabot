//
//  RouteFormatter.swift
//  Pizzabot
//
//  Created by Anastasia Kovaleva on 16.09.21.
//

import Foundation

protocol RouteFormat {
    func isValid(_ value: String) -> Bool
    func obtainRouteString(from value: String) -> String
}

final class RouteFormatter: RouteFormat {

    func isValid(_ value: String) -> Bool {
        let routeString = obtainRouteString(from: value)
        let pattern = "^\\d+x\\d+ *( *[(] *\\d+, *\\d+ *[)] *)+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: routeString)
    }

    func obtainRouteString(from value: String) -> String {
        let allowedCharset = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "+(),x "))
        var routeString = String(value.unicodeScalars.filter(allowedCharset.contains))
        routeString = routeString.trimmingCharacters(in: .whitespacesAndNewlines)

        return routeString
    }

}
