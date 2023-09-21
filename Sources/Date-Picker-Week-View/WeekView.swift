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
}

struct WeekView: View {
    @Binding var date: Date
    
    private static var WeekFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter
    }()
    
    private static var DayFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter
    }()
    
    var body: some View {
        HStack {
            ForEach(date.weekDays(), id: \.self) { weekDay in
                VStack {
                    Text(Self.WeekFormatter.string(from: weekDay))
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
                        
                        Text(Self.DayFormatter.string(from: weekDay))
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
                WeekView(date: $selectedDate)
                Text("Content")
                Spacer()
            }
            
        }
    }
    
    static var previews: some View {
        WeekViewTest()
    }
}
