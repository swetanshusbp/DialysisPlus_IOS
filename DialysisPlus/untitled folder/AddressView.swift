import SwiftUI
import MapKit

struct AnnotationItem: Identifiable, Codable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D

    enum CodingKeys: CodingKey {
        case id, latitude, longitude
    }

    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
    }
}

struct AddressView: View {
    @State private var annotations: [AnnotationItem] = []
    @State private var addressNames: [String] = []
    @State private var newCoordinate: CLLocationCoordinate2D?
    @State private var isAddingNewAddress = false
    @State private var newAddressName = ""
    @State private var newAddress = ""

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 28.6139, longitude: 77.2090),
        span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
    )

    var body: some View {
        VStack {
            HStack {
                ForEach(addressNames, id: \.self) { name in
                    Text(name)
                        .onTapGesture {
                            if let index = addressNames.firstIndex(of: name) {
                                self.newCoordinate = self.annotations[index].coordinate
                            }
                        }
                }
                Spacer()
                Button(action: {
                    self.isAddingNewAddress.toggle()
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                Text("Add New")
            }
            .padding()

            RoundedRectangle(cornerRadius: 25)
                .frame(height: 300)
                .overlay(
                    Map(coordinateRegion: $region, annotationItems: annotations) { annotation in
                        MapPin(coordinate: annotation.coordinate, tint: .blue)
                    }
                    .onAppear {
                        if let newCoordinate = self.newCoordinate {
                            self.region.center = newCoordinate
                            self.region.span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                        }
                    }
                )
                .padding()
        }
        .sheet(isPresented: $isAddingNewAddress) {
            VStack {
                TextField("Name", text: $newAddressName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("Address", text: $newAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button("Submit") {
                    addNewAddress()
                    self.isAddingNewAddress.toggle()
                }
                .padding()
            }
        }
    }

    private func addNewAddress() {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(newAddress) { placemarks, error in
            if let placemark = placemarks?.first {
                if let location = placemark.location {
                    let newCoordinate = location.coordinate
                    self.newCoordinate = newCoordinate
                    self.annotations.append(AnnotationItem(coordinate: newCoordinate))
                    self.addressNames.append(self.newAddressName)
                    self.region = MKCoordinateRegion(
                        center: newCoordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                    )
                }
            }
        }
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView()
    }
}

