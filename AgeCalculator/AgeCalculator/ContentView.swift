import SwiftUI

enum AgeUnit: String, CaseIterable, Identifiable {
    case years = "Years"
    case months = "Months"
    case days = "Days"

    var id: String { rawValue }
}

struct ContentView: View {
    @State private var dateOfBirth = Calendar.current.date(byAdding: .year, value: -25, to: Date()) ?? Date()
    @State private var selectedUnit: AgeUnit = .years
    @State private var ageResult: AgeResult? = nil

    private var maxDate: Date { Date() }
    private var minDate: Date {
        Calendar.current.date(byAdding: .year, value: -150, to: Date()) ?? Date()
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 48))
                        .foregroundColor(.accentColor)
                    Text("Age Calculator")
                        .font(.largeTitle.bold())
                }
                .padding(.top, 32)
                .padding(.bottom, 24)

                ScrollView {
                    VStack(spacing: 24) {
                        // Date Picker Card
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Date of Birth", systemImage: "person.fill")
                                .font(.headline)
                                .foregroundColor(.secondary)

                            DatePicker(
                                "",
                                selection: $dateOfBirth,
                                in: minDate...maxDate,
                                displayedComponents: .date
                            )
                            .datePickerStyle(.graphical)
                            .onChange(of: dateOfBirth) { _ in
                                calculateAge()
                            }
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(16)
                        .padding(.horizontal)

                        // Unit Picker
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Show Age In", systemImage: "ruler")
                                .font(.headline)
                                .foregroundColor(.secondary)

                            Picker("Unit", selection: $selectedUnit) {
                                ForEach(AgeUnit.allCases) { unit in
                                    Text(unit.rawValue).tag(unit)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(16)
                        .padding(.horizontal)

                        // Result Card
                        if let result = ageResult {
                            AgeResultCard(result: result, unit: selectedUnit)
                                .padding(.horizontal)
                        }

                        // Breakdown Card
                        if let result = ageResult {
                            AgeBreakdownCard(result: result)
                                .padding(.horizontal)
                        }

                        Spacer(minLength: 32)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear { calculateAge() }
    }

    private func calculateAge() {
        ageResult = AgeResult.calculate(from: dateOfBirth)
    }
}

struct AgeResultCard: View {
    let result: AgeResult
    let unit: AgeUnit

    private var displayValue: Int {
        switch unit {
        case .years:   return result.years
        case .months:  return result.totalMonths
        case .days:    return result.totalDays
        }
    }

    private var unitLabel: String {
        let val = displayValue
        switch unit {
        case .years:  return val == 1 ? "Year" : "Years"
        case .months: return val == 1 ? "Month" : "Months"
        case .days:   return val == 1 ? "Day" : "Days"
        }
    }

    var body: some View {
        VStack(spacing: 8) {
            Text("You are")
                .font(.title3)
                .foregroundColor(.secondary)

            Text("\(displayValue)")
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .foregroundColor(.accentColor)
                .minimumScaleFactor(0.5)
                .lineLimit(1)

            Text(unitLabel)
                .font(.title2.weight(.semibold))
                .foregroundColor(.primary)

            Text("old")
                .font(.title3)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}

struct AgeBreakdownCard: View {
    let result: AgeResult

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Breakdown", systemImage: "chart.bar.fill")
                .font(.headline)
                .foregroundColor(.secondary)

            HStack(spacing: 12) {
                BreakdownItem(value: result.years, label: result.years == 1 ? "Year" : "Years", color: .blue)
                BreakdownItem(value: result.months, label: result.months == 1 ? "Month" : "Months", color: .green)
                BreakdownItem(value: result.days, label: result.days == 1 ? "Day" : "Days", color: .orange)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}

struct BreakdownItem: View {
    let value: Int
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(color)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
