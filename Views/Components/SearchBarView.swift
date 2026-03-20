import SwiftUI

struct SearchBarView: View {

    @Binding var text: String
    var onTextChange: () -> Void
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(isFocused ? .appAccent : .appSubtitle)
                .animation(.easeInOut(duration: 0.2), value: isFocused)

            TextField("", text: $text, prompt: Text("Search songs, artists…").foregroundColor(.appSubtitle))
                .foregroundColor(.white)
                .font(.system(size: 16))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .focused($isFocused)
                .onChange(of: text) { _ in
                    onTextChange()
                }

            if !text.isEmpty {
                Button {
                    text = ""
                    onTextChange()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.appSubtitle)
                }
                .transition(.opacity.combined(with: .scale))
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 11)
        .background(Color.appSurface)
        .cornerRadius(12)
        .animation(.easeInOut(duration: 0.15), value: text.isEmpty)
    }
}
