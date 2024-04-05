import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct DrinkLogView: View {
    @ObservedObject var fluidData: Fluid
    @StateObject private var viewModel = FluidLogViewModel() // ViewModel to fetch Firestore data
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("customLightGray"))
                .frame(width: 350, height: 200)
                .overlay(
                    VStack(spacing: 20) {
                        Text("Drink Log")
                            .font(.headline)
                            .padding(.top, 10)
                        
                        // Check if Firestore data has been fetched
                        if viewModel.drinkLogs.isEmpty {
                            ProgressView("Loading")
                        } else {
                            List {
                                ForEach(viewModel.drinkLogs.indices, id: \.self) { index in
                                    DrinkLogBoxView(logItem: viewModel.drinkLogs[index])
                                }
                                .onDelete { indexSet in
                                    deleteDrinkLogs(at: indexSet)
                                }
                            }
                            .scrollIndicators(.hidden)
                            .listStyle(.plain)
                            .padding(1)
                        }
                    }
                )
        }
        .onAppear {
            // Fetch Firestore data when view appears
            viewModel.fetchDrinkLogs()
        }
    }
    
    private func deleteDrinkLogs(at offsets: IndexSet) {
        viewModel.deleteDrinkLogs(at: offsets)
    }
}

// ViewModel to fetch and manage Firestore data
private class FluidLogViewModel: ObservableObject {
    @Published var drinkLogs = [DrinkLogItem]()
    
    func fetchDrinkLogs() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Error: No current user found.")
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users").document(currentUserID).collection("FluidLog").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }
            guard let documents = snapshot?.documents else { return }
            self.drinkLogs = documents.compactMap { document in
                guard let id = document.documentID as? String,
                      let ml = document.data()["ml"] as? Int,
                      let time = document.data()["time"] as? String,
                      let drink = document.data()["drink"] as? Int else { return nil }
                return DrinkLogItem(id: id, ml: ml, time: time, drink: drink)
            }
        }
    }
    
    func deleteDrinkLogs(at offsets: IndexSet) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Error: No current user found.")
            return
        }
        
        let db = Firestore.firestore()
        for index in offsets {
            let docID = drinkLogs[index].id
            db.collection("users").document(currentUserID).collection("FluidLog").document(docID).delete { error in
                if let error = error {
                    print("Error deleting document: \(error)")
                } else {
                    DispatchQueue.main.async {
                        // Remove the deleted item from the array
                        self.drinkLogs.removeAll { $0.id == docID }
                    }
                    print("Document deleted successfully")
                }
            }
        }
    }
}

struct DrinkLogBoxView: View {
    var logItem: DrinkLogItem

    var body: some View {
        DrinkLogBox(ml: logItem.ml, time: logItem.time, selectedDrinkIndex: logItem.drink)
            .frame(width: 320, height: 40)
            .padding(.bottom, 10)
    }
}

struct DrinkLogBox: View {
    var ml: Int
    var time: String
    var selectedDrinkIndex: Int

    var body: some View {
        HStack {
            VStack{
                Image(drinkable[selectedDrinkIndex].image)
                    .resizable()
                    .frame(width: 30, height: 30)
                
                Text(drinkable[selectedDrinkIndex].name)
                    .font(.body)
            }
            Spacer()
            Text("\(ml) ml")
                .font(.body)
                .bold()
            Spacer()

            Text(time)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .cornerRadius(10)
        .padding(8)
    }
}

