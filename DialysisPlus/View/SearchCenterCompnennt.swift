import SwiftUI

struct SearchCenterComponent: View {
    @State private var isExpanded: Bool = false
    @GestureState private var dragState = DragState.inactive
    @State private var positionOffset: CGFloat = UIScreen.main.bounds.height / 3
    
    var hospitalname: String
    var smalladdress: String
    var description: String
    var phoneno: String
    var email: String
    var srcaddress: String
    var destiaddress: String
    
    var body: some View {
        VStack{
            Image("background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .frame(minWidth:400, maxHeight:0)
                .zIndex(2.0)
            Image("hospitalImage")
                .resizable()
                .scaledToFit()
                .frame(width: 400)

    
            VStack{
                GeometryReader { geometry in
                   
                    VStack {
                        // Header part with Hospital name and rating
                        VStack(alignment: .leading, spacing: 10) {
                            Text(hospitalname)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text(smalladdress)
                                .font(.subheadline)
                            
                            HStack {
                                ForEach(0..<5) { _ in
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                            
                                }
                            }
                        }
                        .padding()
                        
                        Divider()
                        
                        // About Hospital section
                        VStack(alignment: .leading, spacing: 10) {
                            Text("About Hospital")
                                .font(.headline)
                            
                            Text(description)
                                .font(.body)
                                .lineLimit(isExpanded ? nil : 3)
                            
                            Button(action: {
                                withAnimation {
                                    self.isExpanded.toggle()
                                }
                            }) {
                                Text(isExpanded ? "Read Less" : "Read More")
                                    .font(.body)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                        
                        Divider()
                        
                        // Location map section
                        VStack {
                            Text("Location")
                                .font(.headline)
                            
                            // Replacing the dummy map placeholder with the actual map
                            RoundedMapView(sourceAddress: srcaddress,
                                           destinationAddress:destiaddress )
                                .frame(height: 200)
                                .cornerRadius(8)
                        }
                        .padding()
                        
                        Divider()
                        
                        // Contact section
                        VStack {
                            Text("Contact us at:")
                                .font(.headline)
                            
                            HStack {
                                Image(systemName: "phone.fill")
                                    .foregroundColor(.green)
                                Text(phoneno)
                            }
                            
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(.blue)
                                Text(email)
                            }
                        }
                        .padding()
                    }
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 10)
                    .offset(y: self.positionOffset)
                    .animation(.interactiveSpring())
                    .gesture(
                        DragGesture()
                            .updating($dragState) { drag, state, transaction in
                                state = .dragging(translation: drag.translation)
                            }
                            .onEnded(onDragEnded)
                    )
                }
                .offset(y:-350)
                
                
            }
            .zIndex(3.0)
           
        }
    }


    private func onDragEnded(drag: DragGesture.Value) {
        let dragThreshold = UIScreen.main.bounds.height / 3
        if drag.predictedEndTranslation.height > dragThreshold || drag.translation.height > dragThreshold {
            positionOffset = UIScreen.main.bounds.height / 3
        } else {
            positionOffset = 0
        }
    }

    enum DragState {
        case inactive
        case dragging(translation: CGSize)

        var translation: CGSize {
            switch self {
            case .inactive:
                return .zero
            case .dragging(let translation):
                return translation
            }
        }

        var isDragging: Bool {
            switch self {
            case .dragging:
                return true
            case .inactive:
                return false
            }
        }
    }
}

struct SearchCenterComponent_Previews: PreviewProvider {
    static var previews: some View {
        SearchCenterComponent(hospitalname: "ASTER HOSPITALS", smalladdress: "ECR Road", description: "Aster hospital is one of the top hospitals in the city. With more than 100+ beds and having the top doctors we lead in critical care... [Additional information here] jehvfjhcbes jvjhsdv jh  dvjhd jhs  d vcjd  djd vcjhdsj jhbvjhsdj  hbvhjð jhdvbjh  dv jh  hd vhjd jdhs h  ", phoneno:"+91 1234567890", email: "contactsupport@gmail.com", srcaddress:"SRM Institute of Science and Technology, SRM Nagar, Kattankulathur, Tamil Nadu." ,destiaddress:"Estancia Tower Tower 5, ESTANCIA TOWER, Grand Southern Trunk Rd, Potheri, SRM Nagar, Guduvancheri, Kattankulathur, Tamil Nadu 603203" )
    }
}


