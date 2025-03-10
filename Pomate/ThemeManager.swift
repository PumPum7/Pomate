import SwiftUI

struct ThemeManager {
    static func primaryColor(for theme: PomateSettings.ColorTheme) -> Color {
        switch theme {
        case .system, .light, .dark:
            return Color.accentColor
        case .tomato:
            return Color.red
        case .ocean:
            return Color.blue
        case .forest:
            return Color.green
        }
    }
    
    static func workSessionColor(for theme: PomateSettings.ColorTheme) -> Color {
        switch theme {
        case .tomato:
            return Color.red
        case .ocean:
            return Color(red: 0.2, green: 0.5, blue: 0.8)
        case .forest:
            return Color(red: 0.2, green: 0.7, blue: 0.3)
        default:
            return Color.red
        }
    }
    
    static func shortBreakColor(for theme: PomateSettings.ColorTheme) -> Color {
        switch theme {
        case .tomato:
            return Color.orange
        case .ocean:
            return Color(red: 0.4, green: 0.8, blue: 0.9)
        case .forest:
            return Color(red: 0.6, green: 0.8, blue: 0.4)
        default:
            return Color.blue
        }
    }
    
    static func longBreakColor(for theme: PomateSettings.ColorTheme) -> Color {
        switch theme {
        case .tomato:
            return Color.purple
        case .ocean:
            return Color(red: 0.2, green: 0.4, blue: 0.7)
        case .forest:
            return Color(red: 0.1, green: 0.5, blue: 0.2)
        default:
            return Color.green
        }
    }
    
    static func backgroundGradient(for theme: PomateSettings.ColorTheme) -> LinearGradient {
        switch theme {
        case .tomato:
            return LinearGradient(
                colors: [Color.red.opacity(0.1), Color.orange.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .ocean:
            return LinearGradient(
                colors: [Color.blue.opacity(0.1), Color.cyan.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .forest:
            return LinearGradient(
                colors: [Color.green.opacity(0.1), Color.mint.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        default:
            return LinearGradient(
                colors: [Color.clear, Color.clear],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    static func buttonColor(for theme: PomateSettings.ColorTheme) -> Color {
        switch theme {
        case .tomato:
            return Color.red
        case .ocean:
            return Color.blue
        case .forest:
            return Color.green
        default:
            return Color.accentColor
        }
    }
}
