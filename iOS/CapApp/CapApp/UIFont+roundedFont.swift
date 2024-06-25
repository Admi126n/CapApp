//
//  UIFont+roundedFont.swift
//  CapApp
//
//  Created by Adam Tokarski on 25/06/2024.
//

import UIKit

extension UIFont {
	static func roundedFont(ofSize size: UIFont.TextStyle, weight: UIFont.Weight) -> UIFont {
		let fontSize = UIFont.preferredFont(forTextStyle: size).pointSize
		
		guard let descriptor = UIFont.systemFont(ofSize: fontSize, weight: weight).fontDescriptor.withDesign(.rounded) else {
			return UIFont.preferredFont(forTextStyle: size)
		}
		
		return UIFont(descriptor: descriptor, size: fontSize)
	}
}
