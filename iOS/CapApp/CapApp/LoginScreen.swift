//
//  LoginScreen.swift
//  CapApp
//
//  Created by Adam Tokarski on 01/07/2024.
//

import SwiftUI

struct LoginScreen: View {
	
	@State private var email = ""
	@State private var password = ""
	
    var body: some View {
		VStack {
			Spacer()
			
			Text("Cap App")
				.font(.system(size: 60, weight: .bold, design: .rounded))
				.lineLimit(1)
				.minimumScaleFactor(0.01)
			
			Spacer()
			
			TextField("email", text: $email)
				.keyboardType(.emailAddress)
				.textInputAutocapitalization(.never)
				.padding(8)
				.overlay {
					RoundedRectangle(cornerRadius: 5)
						// TODO: change color if needed on submit
						.stroke(.secondary)
				}
			
			SecureField("password", text: $password)
				.padding(8)
				.overlay {
					RoundedRectangle(cornerRadius: 5)
						.stroke(.secondary, lineWidth: 1)
				}
			
			Button("Don't have an account?") {
				dump("Switch view to create account")
			}
			.font(.subheadline)
		
			Spacer()
			Spacer()
			
			Button("See caps without signing in") {
				dump("Show caps list")
			}
			.font(.subheadline)
			
			Button("Sign in") {
				dump("signing in")
			}
			.buttonStyle(.borderedProminent)
		}
		.padding()
    }
}

#Preview {
    LoginScreen()
}
