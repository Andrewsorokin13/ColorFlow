//
//  MainViewController.swift
//  ColorFlow
//
//  Created by Андрей Сорокин on 03.01.2025.
//

import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func setColor(_ color: UIColor)
    func getRGB(_ red:String, _ green:String, _ blue:String, _ alpha:String)
}

final class MainViewController: UIViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var colorLabel: UILabel!
    
    // MARK: - Overrides Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let settingsVC = segue.destination as? SettingsViewController
        settingsVC?.delegate = self
        settingsVC?.colorMainView = view.backgroundColor
    }
    
}
// MARK: - Conform SettingsViewControllerDelegate

extension MainViewController: SettingsViewControllerDelegate {
    func getRGB(_ red: String, _ green: String, _ blue: String, _ alpha: String) {
        colorLabel.text = "Red: \(red), Green: \(green), Blue: \(blue), Alpha: \(alpha)"
    }
    
    func setColor(_ color: UIColor) {
        view.backgroundColor = color
    }
}
