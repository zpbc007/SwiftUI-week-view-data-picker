import SwiftUI

public struct DatePickerWeekView: View {
    @Binding var date: Date
    
    var lastWeekStartDay: Date {
        Calendar.current.date(
            byAdding: .day,
            value: -7,
            to: date
        )!
    }
    
    var nextWeekStartDay: Date {
        Calendar.current.date(
            byAdding: .day,
            value: 7,
            to: date
        )!
    }
    
    public init(date: Binding<Date>) {
        self._date = date
    }
    
    public var body: some View {
        SwipeView { direction in
            if direction == .left {
                date = lastWeekStartDay
            }
            
            if direction == .right {
                date = nextWeekStartDay
            }
        } contentBuilder: { tabIndex in
            switch tabIndex {
            case .left:
                WeekView(date: .constant(lastWeekStartDay))
                    .frame(minHeight: 0)
            case .center:
                WeekView(date: $date)
                    .frame(minHeight: 0)
            case .right:
                WeekView(date: .constant(nextWeekStartDay))
                    .frame(minHeight: 0)
            }
        }
        .frame(minHeight: 0)
    }
}

struct DatePickerWeekView_Previews: PreviewProvider {
    struct DatePickerWeekViewTestContainer: View {
        @State var selectedDate = Calendar.current.startOfDay(for: Date.now)
        
        var dateString: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            
            return dateFormatter.string(from: selectedDate)
        }
        
        var body: some View {
            VStack {
                HStack {
                    Text("SelectedDay: \(dateString)")
                    Spacer()
                    Button("Today") {
                        withAnimation {
                            selectedDate = Calendar.current.startOfDay(for: Date.now)
                        }
                    }
                }
                
                DatePickerWeekView(date: $selectedDate)
                    .frame(height: 80, alignment: .top)
                
                HStack {
                    Text("Content")
                }
                
                Spacer()
            }
        }
    }
    
    static var previews: some View {
        DatePickerWeekViewTestContainer()
    }
}
