//
//  Pastappview.swift
//  DialysisPlusNew
//
//  Created by admin on 28/12/23.
//
import SwiftUI

struct PastAppView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundColor(.white)
            .frame(width: 350, height: 180)
            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray, lineWidth: 1)
                    .padding(1)
                    .opacity(0.8)
                    .frame(width: 350, height: 180)
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
                                Text("Done")
                            }
                        }
                        .padding()
                    )
            )
    }
}

struct PastAppView_Previews: PreviewProvider {
    static var previews: some View {
        PastAppView()
    }
}


