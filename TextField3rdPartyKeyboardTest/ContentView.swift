//
//  ContentView.swift
//  TextField3rdPartyKeyboardTest
//
//  Created by Thomas on 23/11/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Can show 3rd party keyboard")) {
                    NavigationLink(destination: TextFieldView()) {
                        Text("TextField")
                    }
                    NavigationLink(destination: SecureFieldBeforeTextFieldView()) {
                        Text("SecureField before TextField")
                    }
                }
                Section(header: Text("Cannot show 3rd party keyboard")) {
                    NavigationLink(destination: SecureFieldView()) {
                        Text("SecureField")
                    }
                    NavigationLink(destination: TextFieldBeforeSecureFieldView()) {
                        Text("TextField before SecureField")
                    }
                    NavigationLink(destination: SecureFieldTextFieldSecureFieldView()) {
                        Text("SecureFieldTextFieldSecureFieldView")
                    }
                    NavigationLink(destination: TextFieldSecureFieldTextFieldView()) {
                        Text("TextFieldSecureFieldTextFieldView")
                    }
                }
            }
        }
    }
}

struct SecureFieldView: View {
    @State var text: String = ""
    var body: some View {
        SecureField("Password", text: $text)
        
    }
}

// `TextField` 3rd party keyboard enabled
struct TextFieldView: View {
    @State var email: String = ""
    var body: some View {
        TextField("Email", text: $email)
    }
}

// `TextField` 3rd party keyboard disabled
struct TextFieldBeforeSecureFieldView: View {
    @State var email: String = ""
    @State var password: String = ""
    var body: some View {
        VStack {
            TextField("Email", text: $email)
            SecureField("Password", text: $password)
        }
        
    }
}

// `TextField` 3rd party keyboard enabled
struct SecureFieldBeforeTextFieldView: View {
    @State var email: String = ""
    @State var password: String = ""
    var body: some View {
        VStack {
            SecureField("Password", text: $password)
            TextField("Email", text: $email)
        }
        
    }
}

// `TextField` 3rd party keyboard disabled
struct SecureFieldTextFieldSecureFieldView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var favouriteCat: String = ""
    var body: some View {
        VStack {
            SecureField("Password", text: $password)
            TextField("Email", text: $email)
            SecureField("Favourite cat", text: $favouriteCat)
        }
    }
}

// `TextField` 3rd party keyboard disabled
struct TextFieldSecureFieldTextFieldView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var favouriteCat: String = ""
    var body: some View {
        VStack {
            TextField("Email", text: $email)
            SecureField("Password", text: $password)
            TextField("Favourite cat", text: $favouriteCat)
        }
    }
}

#Preview {
    ContentView()
}
