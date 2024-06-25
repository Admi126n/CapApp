//
//  CodeTextField.swift
//  CapApp
//
//  Created by Adam Tokarski on 25/06/2024.
//

import SwiftUI

struct CodeTextField: View {
	private let emptyColor = Color.init(white: 0.9)
	private let filledColor = Color.green
	private let onDeleteBackward: (() -> Void)?
	
	@Binding var code: String
	
	@State private var isFieldFilled = true
	
	var body: some View {
		UICodeField(
			text: $code,
			onDeleteBackward: {
				onDeleteBackward?()
			}
		)
		.overlay {
			RoundedRectangle(cornerRadius: 5)
				.stroke(isFieldFilled ? emptyColor : filledColor, lineWidth: 1)
		}
		.onChange(of: code) {
			withAnimation {
				isFieldFilled = code.isEmpty
			}
		}
		.frame(height: 50)
	}
	
	init(code: Binding<String>, onDeleteBackward: (() -> Void)? = nil) {
		self._code = code
		self.onDeleteBackward = onDeleteBackward
	}
}

#Preview {
	CodeTextField(code: .constant("")) { }
}

// MARK: - UICodeField
fileprivate struct UICodeField: UIViewRepresentable {
	
	@Binding var text: String
	
	/// Closure called before deleting text
	var onDeleteBackward: (() -> Void)?
	
	func makeUIView(context: Context) -> CustomUITextField {
		let textField = CustomUITextField()
		
		textField.onDeleteBackward = onDeleteBackward
		textField.delegate = context.coordinator
		textField.keyboardType = .numberPad
		textField.font = UIFont.roundedFont(ofSize: .largeTitle, weight: .bold)
		textField.textAlignment = .center
		textField.placeholder = "X"
		
		return textField
	}
	
	func updateUIView(_ uiView: CustomUITextField, context: Context) {
		uiView.text = text
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
}

// MARK: - UICodeField + Coordinator
fileprivate extension UICodeField {
	
	class Coordinator: NSObject, UITextFieldDelegate {
		var parent: UICodeField
		
		init(_ parent: UICodeField) {
			self.parent = parent
		}
		
		func textFieldDidChangeSelection(_ textField: UITextField) {
			Task { @MainActor in
				parent.text = textField.text ?? ""
			}
		}
	}
}

// MARK: - CustomTextField
/// Custom class with disabled `paste` action and with custom backward deleting action
///
/// `onDeleteBackward` is called before deleting text from `UITextField`.
fileprivate class CustomUITextField: UITextField {
	
	/// Closure called before deleting text
	var onDeleteBackward: (() -> Void)?
	
	override func deleteBackward() {
		onDeleteBackward?()
		super.deleteBackward()
	}
	
	// Disable pasting
	override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
		if action == #selector(UIResponderStandardEditActions.paste) {
			return false
		}
		
		return super.canPerformAction(action, withSender: sender)
	}
}

