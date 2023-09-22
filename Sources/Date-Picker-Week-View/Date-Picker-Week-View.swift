import SwiftUI

public struct DatePickerWeekView: View {
    @Binding var date: Date
    @Binding var page: Int
    
    func calculatePageDate(_ page: Int) -> Date {
        Calendar.current.date(
            byAdding: .day,
            value: page * 7,
            to: Date.now.todayStartPoint
        )!
    }
    
    public var body: some View {
        GeometryReader { geometry in
            InfiniteTabPageView(
                width: geometry.size.width,
                page: $page
            ) { page in
                VStack {
                    WeekView(
                        date: $date.animation(.easeOut),
                        weekDays: calculatePageDate(page).weekDays()
                    )
                }
            }
        }
    }
}

struct DatePickerWeekView_Previews: PreviewProvider {
    struct DatePickerWeekViewTestContainer: View {
        @State var date = Calendar.current.startOfDay(for: Date.now)
        @State var page = 0
        
        var dateString: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            
            return dateFormatter.string(from: date)
        }
        
        func calculatePageDate(_ page: Int) -> Date {
            Calendar.current.date(
                byAdding: .day,
                value: page * 7,
                to: Date.now.todayStartPoint
            )!
        }
        
        var body: some View {
            VStack {
                HStack {
                    Text("SelectedDay: \(dateString)")
                    Spacer()
                    Button("Today") {
                        date = Calendar.current.startOfDay(for: Date.now)
                        page = 0
                    }
                }
                
                DatePickerWeekView(
                    date: $date,
                    page: $page
                )
                    .frame(height: 80, alignment: .top)
                
                HStack {
                    Text("Content")
                }
                
                Spacer()
            }
            .onChange(of: page) { newValue in
                // 回到当天
                if (page == 0
                    && self.date == Date.now.todayStartPoint
                ) {
                    return
                }
                self.date = calculatePageDate(newValue)
            }
        }
    }
    
    static var previews: some View {
        DatePickerWeekViewTestContainer()
    }
}
