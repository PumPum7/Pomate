import SwiftUI

// Reusable stat card component
struct StatCard: View {
	let title: String
	let value: String
	let icon: String
	let color: Color

	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			HStack {
				Image(systemName: icon)
					.foregroundColor(color)
				Text(title)
					.font(.caption)
					.foregroundColor(.secondary)
			}

			Text(value)
				.font(.title2)
				.fontWeight(.bold)
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.padding()
		.background(
			RoundedRectangle(cornerRadius: 10)
				.fill(Color.secondary.opacity(0.1))
		)
	}
}
