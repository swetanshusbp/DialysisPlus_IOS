import SwiftUI

struct DetailsView: View {
    let hospitalName: String
    let address: String
    let starRating: Int

    var body: some View {
        VStack {
            Text("Details for \(hospitalName)")
                .font(.title)
                .padding()

            Text("Address: \(address)")
                .padding()

            Text("Star Rating: \(starRating)")
                .padding()

            // Add more details as needed

            Spacer()
        }
    }
}
