import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    let sourceAddress: String
    let destinationAddress: String
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .blue
            renderer.lineWidth = 3.0
            return renderer
        }
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(sourceAddress) { sourcePlacemarks, _ in
            if let sourcePlacemark = sourcePlacemarks?.first {
                geocoder.geocodeAddressString(destinationAddress) { destinationPlacemarks, _ in
                    if let destinationPlacemark = destinationPlacemarks?.first {
                        let sourceAnnotation = MKPointAnnotation()
                        sourceAnnotation.title = "Source"
                        if let sourceLocation = sourcePlacemark.location {
                            sourceAnnotation.coordinate = sourceLocation.coordinate
                            uiView.addAnnotation(sourceAnnotation)
                        }
                        
                        let destinationAnnotation = MKPointAnnotation()
                        destinationAnnotation.title = "Destination"
                        if let destinationLocation = destinationPlacemark.location {
                            destinationAnnotation.coordinate = destinationLocation.coordinate
                            uiView.addAnnotation(destinationAnnotation)
                        }
                        
                        let sourceMapItem = MKMapItem(placemark: MKPlacemark(coordinate: sourceAnnotation.coordinate))
                        let destinationMapItem = MKMapItem(placemark: MKPlacemark(coordinate: destinationAnnotation.coordinate))
                        
                        let directionsRequest = MKDirections.Request()
                        directionsRequest.source = sourceMapItem
                        directionsRequest.destination = destinationMapItem
                        directionsRequest.transportType = .automobile
                        
                        let directions = MKDirections(request: directionsRequest)
                        directions.calculate { response, _ in
                            if let route = response?.routes.first {
                                uiView.addOverlay(route.polyline)
                                uiView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

struct RoundedMapView: View {
    let sourceAddress: String
    let destinationAddress: String
    
    var body: some View {
        MapView(sourceAddress: sourceAddress, destinationAddress: destinationAddress)
            .frame(width: 350, height: 250)
            .cornerRadius(20)
    }
}

struct RouteView: View {
    var sourceAddress =  "SRM Institute of Science and Technology, SRM Nagar, Kattankulathur, Tamil Nadu."
    var destinationAddress =  "Estancia Tower Tower 5, ESTANCIA TOWER, Grand Southern Trunk Rd, Potheri, SRM Nagar, Guduvancheri, Kattankulathur, Tamil Nadu 603203"
    
    var body: some View {
        RoundedMapView(sourceAddress: sourceAddress, destinationAddress: destinationAddress)
            .edgesIgnoringSafeArea(.all)
    }
}

struct RouteView_Previews: PreviewProvider {
    static var previews: some View {
        RouteView()
    }
}

