import SwiftUI

struct NewAppView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.white)
                    
                    .frame(width: 350, height: 200)
                    .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                    .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.gray, lineWidth: 1) // Grey border
                                        .padding(1) // Adjust the padding as needed
                                        .opacity(0.8) // Adjust opacity if required
                                        .frame(width: 350, height: 200)

                    .overlay(
                        VStack(spacing: 10) {
                            HStack {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Aster Hospital")
                                        .bold()
                                    Text("ECR")
                                    Image("Group 24")
                                }
                                Spacer()
                                
                                Image("image 40")
                            }
                            
                            Image("line")
                                .resizable()
                                .frame(width: 300, height: 0.5)
                                
                            
                            HStack {
                                Image("calendar")
                                Text("12/12/2023")
                                Image("time")
                                Text("10:00")
                                Image("circlegreen")
                                    .foregroundColor(.green)
                                Text("Confirmed")
                            }
                            
                            HStack {
                                Button(action: {
                                    
                                }) {
                                    Text("Cancle                  ")
                                        
                                        .multilineTextAlignment(.center)
                                        .padding()
                                        .foregroundColor(.white)
                                        .background(Color(hex:"072AC8"))
                                        .cornerRadius(25)
                                }
                                
                                Text("Reschedule          ")
                                    
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .foregroundColor(.black)
                                    .background(Color(hex:"A2D6F9"))
                                    .cornerRadius(25)
                            }
                        }
                        .padding()
                    )
                                    )
    }
}

struct NewAppView_Previews: PreviewProvider {
    static var previews: some View {
       NewAppView()
    }
}


