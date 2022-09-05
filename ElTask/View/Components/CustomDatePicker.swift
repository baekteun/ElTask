//
//  CustomDatePicker.swift
//  ElTask
//
//  Created by 최형우 on 2022/09/05.
//

import SwiftUI

struct CustomDatePicker: View {
    @Binding var currentDate: Date
    
    @State var currentMonth = 0
    
    let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        VStack(spacing: 35) {
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("\(extraDate()[0])")
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                    Text("\(extraDate()[1])")
                        .font(.title.bold())
                }
                
                Spacer(minLength: 0)
                    
                Button {
                    withAnimation {
                        currentMonth -= 1
                    }
                } label: {
                    Image(systemName: "chevron.left")
                }
                
                Button {
                    withAnimation {
                        currentMonth += 1
                    }
                } label: {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.horizontal)
            
            // Day View
            HStack(spacing: 0) {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Dates
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(extractDate()) { value in
                    DateCardView(value: value)
                        .background(
                            Capsule()
                                .fill(Color("Pink"))
                                .padding(.horizontal, 8)
                                .opacity(isSameDay(value.date, currentDate) ? 1 : 0)
                        )
                        .onTapGesture {
                            currentDate = value.date
                        }
                }
            }
            
            VStack(spacing: 20) {
                Text("Tasks")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 20)
                
                if let task = tasks.first(where: { task in
                    return isSameDay(task.taskDate, currentDate)
                }) {
                    ForEach(task.tasks) { task in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(task.time.addingTimeInterval(CGFloat.random(in: 0...5000)), style: .time)
                            
                            Text(task.title)
                                .font(.title2.bold())
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            Color("Purple")
                                .opacity(0.5)
                                .cornerRadius(10)
                        )
                    }
                } else {
                    Text("No Task Found")
                }
            }
            .padding()
            .padding(.top, 20)
            
            
        }
        .onChange(of: currentMonth) { newValue in
            currentDate = getCurrentMonth()
        }
    }
    
    @ViewBuilder
    func DateCardView(value: DateValue) -> some View {
        VStack {
            if value.day != -1 {
                if let task = tasks.first(where: { task in
                    return isSameDay(task.taskDate, value.date)
                }) {
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(task.taskDate, currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    Circle()
                        .fill(isSameDay(task.taskDate, currentDate) ? .white : Color("Pink"))
                        .frame(width: 8, height: 8)
                } else {
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(value.date, currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                }
            }
        }
        .padding(.vertical, 9)
        .frame(height: 60, alignment: .top)
    }
    
    func isSameDay(_ lhs: Date, _ rhs: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(lhs, inSameDayAs: rhs)
    }
    
    func extraDate() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"

        let date = formatter.string(from: currentDate)
        return date.components(separatedBy: " ")
    }
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        guard let currentMonth = calendar.date(byAdding: .month, value: currentMonth, to: Date()) else { return Date() }
        
        return currentMonth
    }
    
    func extractDate() -> [DateValue] {
        let calendar = Calendar.current
        let currentMonth = getCurrentMonth()
        
        var days: [DateValue] = currentMonth.getAllDatesByCurrentMonth().compactMap {
            let day = calendar.component(.day, from: $0)
            return DateValue(day: day, date: $0)
        }
        
        let firstWeekDay = calendar.component(.weekday, from: days.first?.date ?? .init())
        
        for _ in 0..<firstWeekDay - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        return days
    }
}

struct CustomDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Date {
    func getAllDatesByCurrentMonth() -> [Date] {
        let calendar = Calendar.current
        
        let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: self))!
        let range = calendar.range(of: .day, in: .month, for: self)!
        
        return range.compactMap { calendar.date(byAdding: .day, value: $0 - 1, to: startDate) }
    }
}
