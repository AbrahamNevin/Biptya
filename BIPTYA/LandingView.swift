import SwiftUI

struct LandingView: View {
    
    // Custom BIPTYA Color (#B5670D)
    let biptyaColor = Color(
        red: 181/255,
        green: 103/255,
        blue: 13/255
    )
    
    var body: some View {
        ZStack {
            // Background Image
            Image("Landingscreen")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Button(action: {
                    print("Start tapped")
                }) {
                    Text("START")
                        .font(.system(size: 32, weight: .black))
                        .foregroundColor(.white)
                        .padding(.horizontal, 70)
                        .padding(.vertical, 22)
                        .background(
                            ZStack {
                                biptyaColor
                                
                                LinearGradient(
                                    colors: [Color.white.opacity(0.15), Color.black.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                
                                Image(systemName: "grain")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .opacity(0.05)
                            }
                        )
                        .cornerRadius(25)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.white.opacity(0.8), lineWidth: 4)
                        )
                        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 5, y: 10)
                }
                .rotation3DEffect(.degrees(-15), axis: (x: 0, y: 1, z: 0))
                .rotationEffect(.degrees(2))
                // SHIFT: Moves the button 10 units to the right
                .offset(x: 38)
                .padding(.bottom, 210)
            }
        }
    }
}

#Preview {
    LandingView()
}
