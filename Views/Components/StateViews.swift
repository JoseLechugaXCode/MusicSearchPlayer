import SwiftUI


struct LoadingView: View {
    var message: String = "Loading…"

    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .appAccent))
                .scaleEffect(1.4)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.appSubtitle)
        }
    }
}


struct ErrorView: View {
    var message: String

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 44))
                .foregroundColor(.orange)
            Text("Something went wrong")
                .font(.headline)
                .foregroundColor(.white)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.appSubtitle)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
    }
}
