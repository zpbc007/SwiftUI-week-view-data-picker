//
//  SwiftUIView.swift
//  
//
//  Created by zhaopeng on 2023/9/21.
//

import SwiftUI

extension Date {
    /// 获取 date 所在周的所有日期
    func weekDays() -> [Date] {
        var result: [Date] = .init()

        guard let startOfWeek = Calendar.current.date(
            from: Calendar.current.dateComponents(
                [.yearForWeekOfYear, .weekOfYear],
                from: self
            )
        ) else {
            return result
        }

        (0...6).forEach { day in
            if let weekday = Calendar.current.date(
                byAdding: .day,
                value: day,
                to: startOfWeek
            ) {
                result.append(weekday)
            }
        }

        return result
    }
    
    func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.dateFormat = format

        return formatter.string(from: self)
    }
    
    var todayStartPoint: Date {
        Calendar.current.startOfDay(for: self)
    }
}

struct WeekView: View {
    @Binding var date: Date
    var weekDays: [Date]
    var id: String = ""
    
    var body: some View {
        HStack {
            ForEach(weekDays, id: \.self) { weekDay in
                VStack {
                    Text(weekDay.toString(format: "EEE"))
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .frame(maxWidth:.infinity)
                    Spacer()
                        .frame(height: 4)
                    ZStack {
                        HStack{
                            Spacer()
                                .frame(width: 5)
                            Circle()
                                .foregroundColor(weekDay == date ? .accentColor : .clear)
                            Spacer()
                                .frame(width: 5)
                        }
                        
                        Text(weekDay.toString(format: "d"))
                            .font(.system(size: 16))
                            .monospaced()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(weekDay == date ? .white : .primary)
                    }
                }.onTapGesture {
                    date = weekDay
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
    }
}

struct WeekView_Previews: PreviewProvider {
    struct WeekViewTest: View {
        @State var selectedDate = Calendar.current.startOfDay(for: Date())
        
        var body: some View {
            VStack {
                Text("Header")
                WeekView(date: $selectedDate, weekDays: selectedDate.weekDays())
                Text("Content")
                Spacer()
            }
            
        }
    }
    
    static var previews: some View {
        WeekViewTest()
    }
}
