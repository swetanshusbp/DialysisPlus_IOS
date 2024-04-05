import SwiftUI

struct FeedbackView: View {
    @State private var feedbackText = ""
    @State private var rating = 0
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        // Action for the cross button
                    }) {
                        Image(systemName: "multiply")
                            .resizable()
                            .foregroundColor(.black)
                            .background(Color.blue)
                            .frame(width: 25, height: 25) // Adjust button size
                            .cornerRadius(25)
                            .padding(10)
                    }
                }
                
                Text("We appreciate your feedback")
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding()
                
                Text("We are always looking for ways to improve your experience. Please take a moment to evaluate and tell us what you think.")
                    .multilineTextAlignment(.center)
                    .padding()
                
                HStack {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: index <= rating ? "star.fill" : "star.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(index <= rating ? .yellow : .gray)
                            .onTapGesture {
                                // Action when a star is tapped (you can set the rating here)
                                rating = index
                                 
                                
                            }
                    }
                }
                .padding()
                
                TextField("What can we do to improve your experience?", text: $feedbackText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    // Action for the "Submit My Feedback" button
                }) {
                    Text("Submit My Feedback")
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color(hex: "072AC8"))
                        .cornerRadius(25)
                }
                .padding()
            }
            .background(Color(hex: "A2D6F9"))
            .cornerRadius(20)
            .padding()
        }
    }
}

struct FeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackView()
    }
}


