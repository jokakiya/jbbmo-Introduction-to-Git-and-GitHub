import Foundation

struct AgeResult {
    let years: Int
    let months: Int
    let days: Int
    let totalMonths: Int
    let totalDays: Int

    static func calculate(from dob: Date, to today: Date = Date()) -> AgeResult? {
        guard dob <= today else { return nil }

        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: dob, to: today)

        let years = components.year ?? 0
        let months = components.month ?? 0
        let days = components.day ?? 0

        let totalMonthsComponents = calendar.dateComponents([.month], from: dob, to: today)
        let totalMonths = totalMonthsComponents.month ?? 0

        let totalDaysComponents = calendar.dateComponents([.day], from: dob, to: today)
        let totalDays = totalDaysComponents.day ?? 0

        return AgeResult(
            years: years,
            months: months,
            days: days,
            totalMonths: totalMonths,
            totalDays: totalDays
        )
    }
}
