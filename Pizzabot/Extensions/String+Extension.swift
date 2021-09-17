//
//  String+Extension.swift
//  Pizzabot
//
//  Created by Anastasia Kovaleva on 15.09.21.
//

extension String {

    func toTuple(separator: String) -> (Int, Int) {
        let array = components(separatedBy: separator)
        guard let firstItem = Int(array.first ?? ""),
              let secondItem = Int(array.last ?? "") else { return (0, 0) }
        return (firstItem, secondItem)
    }

}
