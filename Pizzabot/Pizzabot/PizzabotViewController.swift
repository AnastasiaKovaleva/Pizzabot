//
//  ViewController.swift
//  Pizzabot
//
//  Created by Anastasia Kovaleva on 15.09.21.
//

import UIKit.UIViewController

typealias Coordinate = (x: Int, y: Int)

final class PizzabotViewController: UIViewController {

    private let routeFormat: RouteFormat = RouteFormatter()

    private let answerLabel = UILabel()
    private let pathTextField = UITextField()

    private var currentCoordinate: Coordinate = (0, 0)

    private var route = [Instruction]() {
        willSet {
            switch newValue.last {
            case .moveNorth:
                currentCoordinate.y += 1
            case .moveSouth:
                currentCoordinate.y -= 1
            case .moveEast:
                currentCoordinate.x += 1
            case .moveWest:
                currentCoordinate.x -= 1
            case .dropPizza, .none:
                return
            }
        }
    }

    private enum Instruction: String {
        case moveNorth = "N"
        case moveSouth = "S"
        case moveEast = "E"
        case moveWest = "W"
        case dropPizza = "D"
    }

    private enum Constants {
        static let fontSize: CGFloat = 22
        static let borderWidth: CGFloat = 1
        static let cornerRadius: CGFloat = 4
        static let spacingToEdges: CGFloat = 40
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        pathTextField.resignFirstResponder()
        guard let pathString = pathTextField.text,
              !pathString.isEmpty,
              let route = pizzabot(path: pathString)
        else { return }
        showResult(route, textColor: .label)
    }

}

// MARK: UI

extension PizzabotViewController {

    private func setupUI() {
        view.backgroundColor = .systemBackground

        pathTextField.placeholder = "Enter path"
        pathTextField.font = .systemFont(ofSize: Constants.fontSize)
        pathTextField.textAlignment = .center
        pathTextField.layer.borderWidth = Constants.borderWidth
        pathTextField.layer.borderColor = UIColor.lightGray.cgColor
        pathTextField.layer.cornerRadius = Constants.cornerRadius
        pathTextField.minimumFontSize = 0.5
        pathTextField.adjustsFontSizeToFitWidth = true
        pathTextField.delegate = self

        view.addSubview(pathTextField)
        pathTextField.translatesAutoresizingMaskIntoConstraints = false
        pathTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        pathTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.spacingToEdges).isActive = true
        pathTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.spacingToEdges).isActive = true
        pathTextField.heightAnchor.constraint(equalToConstant: Constants.spacingToEdges).isActive = true

        answerLabel.font = .boldSystemFont(ofSize: Constants.fontSize)
        answerLabel.textAlignment = .center
        answerLabel.textColor = .label
        answerLabel.numberOfLines = 0
        answerLabel.isHidden = true

        view.addSubview(answerLabel)
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.topAnchor.constraint(equalTo: pathTextField.bottomAnchor, constant: 20).isActive = true
        answerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.spacingToEdges).isActive = true
        answerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.spacingToEdges).isActive = true
        answerLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.spacingToEdges).isActive = true
    }

    private func showResult(_ text: String, textColor: UIColor) {
        answerLabel.isHidden = false
        answerLabel.textColor = textColor
        answerLabel.text = text
    }
    
}

// MARK: Pizzabot

extension PizzabotViewController {

    func pizzabot(path: String) -> String? {
        currentCoordinate = (0, 0)
        route.removeAll()
        guard let coordinates = getCoordinates(from: path) else { return nil }

        coordinates.forEach { coordinate in
            while currentCoordinate.x != coordinate.x {
                if currentCoordinate.x < coordinate.x {
                    route.append(.moveEast)
                } else if currentCoordinate.x > coordinate.x {
                    route.append(.moveWest)
                }
            }

            while currentCoordinate.y != coordinate.y {
                if currentCoordinate.y < coordinate.y {
                    route.append(.moveNorth)
                } else if currentCoordinate.y > coordinate.y {
                    route.append(.moveSouth)
                }
            }
            route.append(.dropPizza)
        }
        return route.map { $0.rawValue }.joined(separator: " ")
    }

    func getCoordinates(from pathString: String) -> [Coordinate]? {
        let path = routeFormat.obtainRouteString(from: pathString)
        guard routeFormat.isValid(path) else {
            showResult("Wrong format \n Use: NxN (N, N) (N, N)...", textColor: .red)
            return nil
        }

        let sizeString = path.components(separatedBy: " ").first ?? ""
        let size: Coordinate = sizeString.toTuple(separator: "x")

        var pathString = path.replacingOccurrences(of: sizeString, with: "")
        pathString.removeFirst()

        let coordinatesString = pathString
            .components(separatedBy: CharacterSet(charactersIn: "()"))
            .filter { $0 != "" && $0 != " " }

        let coordinates: [Coordinate] = coordinatesString.map { $0.toTuple(separator: ", ") }

        var isError = false
        coordinates.forEach { coordinate in
            guard coordinate.x <= size.x,
                  coordinate.y <= size.y else {
                isError = true
                showResult("Coordinates out of range", textColor: .red)
                return
            }
        }

        return isError ? nil : coordinates
    }

}

// MARK: UITextFieldDelegate

extension PizzabotViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let pathString = pathTextField.text,
              !pathString.isEmpty,
              let route = pizzabot(path: pathString)
        else { return true }
        showResult(route, textColor: .label)
        return true
    }

}
