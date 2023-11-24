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
                    NavigationLink(destination: TextFieldTextContentTypePassword()) {
                        Text("TextFieldTextContentTypePassword")
                    }
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
                Section(header: Text("WIP")) {
                    NavigationLink(destination: ToggleHideShowTextView()) {
                        Text("ToggleHideShowTextView")
                    }
                    NavigationLink(destination: ToggleAddRemoveTextView()) {
                        Text("ToggleAddRemoveTextView")
                    }
                    NavigationLink(destination: ViewBuilderView()) {
                        Text("ViewBuilderView")
                    }
                    if #available(iOS 15, *) {
                        NavigationLink(destination: ToggleHideShowWithFocus()) {
                            Text("ToggleHideShowWithFocus")
                        }
                    }
                    NavigationLink(destination: PasswordVisibilityView()) {
                        Text("PasswordVisibilityView")
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
struct TextFieldTextContentTypePassword: View {
    @State var text: String = ""
    var body: some View {
        TextField("Password", text: $text)
            .textContentType(.password)
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

// MARK: Mask/unmask

// should I add: .autocapitalization(.none) and .disableAutocorrection(true)

// use z-stack and add/remove `SecureField` and `TextField` bound to $password from view heirachy.
// keyboard dissmisses on toggle
struct ToggleAddRemoveTextView: View {
    @State var password: String = ""
    @State private var passwordVisible: Bool = false
    
    var body: some View {
        ZStack(alignment: .trailing) {
            Group {
                if passwordVisible {
                    SecureField("Password", text: $password)
                } else {
                    TextField("Password", text: $password)
                }
            }.textContentType(.password)
            Button(action: {
                passwordVisible.toggle()
            }) {
                Image(systemName: self.passwordVisible ? "eye.slash" : "eye")
                    .accentColor(.gray)
            }
        }
    }
}

// Use z-stack with opacity to hide and show `SecureField` and `TextField`
// Keyboard stays open then toggling
struct ToggleHideShowTextView: View {
    @State var password: String = ""
    @State private var passwordVisible: Bool = false
    
    var body: some View {
        ZStack(alignment: .trailing) {
            TextField("Password", text: $password)
                .textContentType(.password)
                .opacity(passwordVisible ? 1.0 : 0.0)
            SecureField("Password", text: $password)
                .opacity(passwordVisible ? 0.0 : 1.0)
            Button(action: {
                passwordVisible.toggle()
            }) {
                Image(systemName: self.passwordVisible ? "eye.slash" : "eye")
                    .accentColor(.gray)
            }
        }
    }
}

// keyboard dissmisses on toggle
struct ViewBuilderView: View {
    @State var text: String = ""
    @State var showPassword = false
    var body: some View {
        HStack{
            Image(systemName: "lock.fill")
                .foregroundColor(text.isEmpty ? .secondary : .primary)
                .font(.system(size: 18, weight: .medium, design: .default))
                .frame(width: 18, height: 18, alignment: .center)
            secureField()
            if !text.isEmpty {
                Button(action: {
                    self.showPassword.toggle()
                }, label: {
                    ZStack(alignment: .trailing){
                        Color.clear
                            .frame(maxWidth: 29, maxHeight: 60, alignment: .center)
                        Image(systemName: self.showPassword ? "eye.slash.fill" : "eye.fill")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color.init(red: 160.0/255.0, green: 160.0/255.0, blue: 160.0/255.0))
                    }
                })
            }
        }
        .padding(.horizontal, 15)
        .background(Color.primary.opacity(0.05).cornerRadius(10))
        .padding(.horizontal, 15)
    }
    
    @ViewBuilder
    func secureField() -> some View {
        if self.showPassword {
            TextField("Password", text: $text)
                .font(.system(size: 15, weight: .regular, design: .default))
                .keyboardType(.default)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .textContentType(.password)
                .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: 60, alignment: .center)
        } else {
            SecureField("Password", text: $text)
                .font(.system(size: 15, weight: .regular, design: .default))
                .keyboardType(.default)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .textContentType(.password)
                .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: 60, alignment: .center)
        }
    }
}

@available(iOS 15.0, *)
struct ToggleHideShowWithFocus: View {
    
    @FocusState var focus1: Bool
    @FocusState var focus2: Bool
    @State var showPassword: Bool = false
    @State var text: String = ""
    
    var body: some View {
        HStack {
            ZStack(alignment: .trailing) {
                TextField("Password", text: $text)
                    .modifier(LoginModifier())
                    .textContentType(.password)
                    .focused($focus1)
                    .opacity(showPassword ? 1 : 0)
                SecureField("Password", text: $text)
                    .modifier(LoginModifier())
                    .textContentType(.password)
                    .focused($focus2)
                    .opacity(showPassword ? 0 : 1)
                Button(action: {
                    showPassword.toggle()
                    if showPassword { focus1 = true } else { focus2 = true }
                }, label: {
                    Image(systemName: self.showPassword ? "eye.slash.fill" : "eye.fill").font(.system(size: 16, weight: .regular))
                        .padding()
                })
            }
        }
    }
}

struct LoginModifier: ViewModifier {
    var borderColor: Color = Color.gray
    func body(content: Content) -> some View {
        content
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(borderColor, lineWidth: 1))
    }
}

struct PasswordVisibilityView: View {
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false

    var body: some View {
        TextField("Password", text: $password)
            .modifier(PasswordVisibilityModifier(isVisible: $isPasswordVisible))
            .overlay(
                HStack {
                    Spacer()
                    Button(action: {
                        self.isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
            )
    }
}

struct PasswordVisibilityModifier: ViewModifier {
    @Binding var isVisible: Bool

    func body(content: Content) -> some View {
        content
            .textContentType(.password)
            .keyboardType(.default)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .textCase(nil)
            .foregroundColor(.primary)
            .font(.system(size: 18))
            .overlay(
                isVisible ? nil : Color.clear.mask(SecureInputMask())
            )
    }
}

struct SecureInputMask: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                for x in stride(from: 0, to: geometry.size.width, by: 10) {
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                }
            }
            .stroke(Color.primary, lineWidth: 2)
        }
    }
}


//#Preview {
//    ContentView()
//}
