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
	
	@State private var codes = ["", "", "", "", ""]
	
	var body: some View {
		HStack(spacing: 8) {
			CodeField(code: $codes[0])
				.focused($focusedField, equals: .first)
			
			CodeField(code: $codes[1])
				.focused($focusedField, equals: .second)
			
			CodeField(code: $codes[2])
				.focused($focusedField, equals: .third)
			
			CodeField(code: $codes[3])
				.focused($focusedField, equals: .fourth)
			
			CodeField(code: $codes[4])
				.focused($focusedField, equals: .fifth)
		}
		.keyboardType(.numberPad)
		.multilineTextAlignment(.center)
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


// MARK: - CodeField
fileprivate struct CodeField: View {
	
	private let emptyColor = Color.init(white: 0.9)
	private let filledColor = Color.green
	
	@Binding var code: String
	
	@State private var isFieldFilled = true
	
	var body: some View {
		TextField("X", text: $code)
			.padding(4)
			.overlay {
				RoundedRectangle(cornerRadius: 5)
					.stroke(isFieldFilled ? emptyColor : filledColor, lineWidth: 1)
			}
			.onChange(of: code) {
				withAnimation {
					isFieldFilled = code.isEmpty
				}
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
}

#Preview {
	CodeVerification(code: .constant(""))
}
