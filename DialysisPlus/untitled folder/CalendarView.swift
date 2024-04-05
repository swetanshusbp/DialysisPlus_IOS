
import SwiftUI

struct CalendarView: View {
    @State private var date = Date()
    var body: some View {
        DatePicker(
                "Start Date",
                selection: $date,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: .gray, radius: 4, x: 2, y: 2)
            .frame(width: 350)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
            
    }
}
