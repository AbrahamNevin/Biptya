import SwiftUI

struct BridgeSceneView: View {
    // 1. State for position and game status
    @State private var dragOffset: CGSize = CGSize(width: 0, height: -250)
    @State private var isPlaced: Bool = false
    @State private var showNextButton: Bool = false
    
    // 2. The "Right Place" coordinates
    let targetLocation = CGSize(width: 120, height: -90)
    let snapTolerance: CGFloat = 50.0
    
    let biptyaColor = Color(red: 181/255, green: 103/255, blue: 13/255)
    
    var body: some View {
        ZStack {
            // --- DYNAMIC BACKGROUND ---
            Image("Scene1Base")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .opacity(isPlaced ? 1.0 : 0.6) // Clears the grey tint when placed
                .animation(.easeInOut(duration: 1.0), value: isPlaced)
            
            // HUD / Instructions
            VStack {
                Text(isPlaced ? "WAY SECURED" : "DRAG THE CORRIDOR TO THE HIGHWAY")
                    .font(.system(size: 16, weight: .black))
                    .tracking(2)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(8)
                    .padding(.bottom, 60)
                
                Spacer()
                
                if showNextButton {
                    Button(action: {
                        print("Navigating to next scene...")
                    }) {
                        Text("CONTINUE JOURNEY")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .padding()
                            .background(biptyaColor)
                            .cornerRadius(10)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 50)
                }
            }
            
            // 3. THE GHOST GUIDE
            if !isPlaced {
                Image("bridge")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 1000)
                    .opacity(0.2)
                    .offset(targetLocation)
                    .id("ghost_bridge_unique")
                    .transition(.opacity)
            }
            
            // 4. THE DRAGGABLE BRIDGE
            Image("bridge")
                .resizable()
                .scaledToFit()
                .frame(width: 1000)
                .shadow(color: .black.opacity(isPlaced ? 0 : 0.5), radius: 15)
                .scaleEffect(isPlaced ? 1.05 : 1.0)
                .offset(dragOffset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if !isPlaced {
                                self.dragOffset = CGSize(
                                    width: value.translation.width,
                                    height: -250 + value.translation.height
                                )
                            }
                        }
                        .onEnded { value in
                            checkPlacement()
                        }
                )
                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: dragOffset)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // 5. Logic to verify drop location
    private func checkPlacement() {
        let xDist = abs(dragOffset.width - targetLocation.width)
        let yDist = abs(dragOffset.height - targetLocation.height)
        
        if xDist < snapTolerance && yDist < snapTolerance {
            withAnimation(.spring()) {
                dragOffset = targetLocation
                isPlaced = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation {
                    showNextButton = true
                }
            }
        } else {
            withAnimation(.spring()) {
                dragOffset = CGSize(width: 0, height: -250)
            }
        }
    }
}
