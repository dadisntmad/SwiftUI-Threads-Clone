import Foundation

extension Date {
    func formatThreadDate() -> String {
        let calendar = Calendar.current
        let now = Date()
        
        let safeDate = self > now ? now : self
        
        if now.timeIntervalSince(safeDate) < 5 {
            return "Just now"
        }
        
        if calendar.isDateInToday(safeDate) {
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .short
            return formatter.localizedString(for: safeDate, relativeTo: now)
        }
        
        if calendar.isDateInYesterday(safeDate) {
            return "Yesterday"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: safeDate)
    }
}
