//
//  CodeVerification.swift
//  CapApp
//
//  Created by Adam Tokarski on 22/06/2024.
//

import SwiftUI

struct CodeVerification: View {
	
	@Binding var code: String
	
	@FocusState private var focusedField: FocusedField?
	
	@State private var codes = Array(repeating: "", count: 5)
	
	var body: some View {
		HStack(spacing: 8) {
			CodeTextField(code: $codes[0], onDeleteBackward: switchOnDelete)
				.focused($focusedField, equals: .first)
			
			CodeTextField(code: $codes[1], onDeleteBackward: switchOnDelete)
				.focused($focusedField, equals: .second)
			
			CodeTextField(code: $codes[2], onDeleteBackward: switchOnDelete)
				.focused($focusedField, equals: .third)
			
			CodeTextField(code: $codes[3], onDeleteBackward: switchOnDelete)
				.focused($focusedField, equals: .fourth)
			
			CodeTextField(code: $codes[4], onDeleteBackward: switchOnDelete)
				.focused($focusedField, equals: .fifth)
		}
		.padding()
		.onAppear {
			focusedField = .first
		}
		.onChange(of: codes) {
			cutCodes()
			switchFocus()
			setCode()
		}
	}
}

// MARK: - FocusedField
fileprivate enum FocusedField {
	case first
	case second
	case third
	case fourth
	case fifth
}

// MARK: - Actions
extension CodeVerification {
	
	/// Cuts codes values so that only last character remains in text field
	private func cutCodes() {
		switch focusedField {
		case .first:
			codes[0] = String(codes[0].suffix(1))
		case .second:
			codes[1] = String(codes[1].suffix(1))
		case .third:
			codes[2] = String(codes[2].suffix(1))
		case .fourth:
			codes[3] = String(codes[3].suffix(1))
		default:
			codes[4] = String(codes[4].suffix(1))
		}
	}
	
	/// Sets `code` as joined value of `codes` elements
	private func setCode() {
		code = codes.joined()
	}
	
	/// Switches focus to next field if selected field is filled
	private func switchFocus() {
		switch focusedField {
		case .first:
			if !codes[0].isEmpty {
				focusedField = .second
			}
		case .second:
			if !codes[1].isEmpty {
				focusedField = .third
			}
		case .third:
			if !codes[2].isEmpty {
				focusedField = .fourth
			}
		case .fourth:
			if !codes[3].isEmpty {
				focusedField = .fifth
			}
		default:
			if !codes[4].isEmpty {
				focusedField = nil
			}
		}
	}
	
	/// Switches focus to previous code field if current if empty
	private func switchOnDelete() {
		switch focusedField {
		case .second:
			if codes[1].isEmpty {
				codes[0] = ""
				focusedField = .first
			}
		case .third:
			if codes[2].isEmpty {
				codes[1] = ""
				focusedField = .second
			}
		case .fourth:
			if codes[3].isEmpty {
				codes[2] = ""
				focusedField = .third
			}
		case .fifth:
			if codes[4].isEmpty {
				codes[3] = ""
				focusedField = .fourth
			}
		default:
			()
		}
	}
}

#Preview {
	CodeVerification(code: .constant(""))
}
