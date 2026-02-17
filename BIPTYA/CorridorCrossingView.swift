import SwiftUI

struct CorridorCrossingView: View {
    @State private var biptyaOffset = CGSize(width: -250, height: 0)
    @State private var isCrossing = false
    @State private var hasFinishedCrossing = false
    @State private var isPulsing = false
    
    // NEW: State to trigger the final ending screen
    @State private var goToEnding = false
    
    @State private var autoRotation: Double = 0.0
    
    let bridgeEntrance = CGSize(width: -510, height: -100)
    let snapTolerance: CGFloat = 80.0
    let biptyaColor = Color(red: 181/255, green: 103/255, blue: 13/255)
    
    private var currentTilt: Double {
        if isCrossing {
            return autoRotation
        } else {
            let frequency = 0.15
            let amplitude = 10.0
            return sin(biptyaOffset.width * frequency) * amplitude
        }
    }

    var body: some View {
        ZStack {
            Image("nightCorridor")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            // Visual Cue
            if !isCrossing {
                ZStack {
                    Circle()
                        .stroke(Color.green, lineWidth: 3)
                        .frame(width: 120, height: 120)
                        .background(Circle().fill(Color.green.opacity(0.2)))
                    Text("PLACE\nHERE")
                        .font(.system(size: 12, weight: .black))
                        .foregroundColor(.green)
                        .multilineTextAlignment(.center)
                }
                .offset(bridgeEntrance)
                .scaleEffect(isPulsing ? 1.1 : 0.9)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) { isPulsing = true }
                }
            }
            
            // HUD
            VStack {
                Text(hasFinishedCrossing ? "SAFE PASSAGE" : "GUIDE BIPTYA ACROSS THE BRIDGE")
                    .font(.system(size: 16, weight: .black))
                    .tracking(2)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(8)
                    .padding(.top, 60)
                
                Spacer()
                
                if hasFinishedCrossing {
                    // UPDATED: Button now triggers navigation
                    Button(action: { goToEnding = true }) {
                        Text("CONTINUE STORY")
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
            
            // --- THE BIPTYA (Leopard) ---
            Image("biptya_walk")
                .resizable()
                .scaledToFit()
                .frame(width: 160)
                .rotationEffect(.degrees(currentTilt))
                .offset(biptyaOffset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if !isCrossing {
                                self.biptyaOffset = CGSize(
                                    width: value.translation.width - 250,
                                    height: value.translation.height
                                )
                            }
                        }
                        .onEnded { _ in checkBridgeEntrance() }
                )
        }
        .navigationBarBackButtonHidden(true)
        // NEW: Navigation Destination to the Ending Screen
        .navigationDestination(isPresented: $goToEnding) {
            CoexistenceEndingView()
        }
    }
    
    private func checkBridgeEntrance() {
        let xDist = abs(biptyaOffset.width - bridgeEntrance.width)
        let yDist = abs(biptyaOffset.height - bridgeEntrance.height)
        
        if xDist < snapTolerance && yDist < snapTolerance {
            startCrossingAnimation()
        } else {
            withAnimation(.spring()) { biptyaOffset = CGSize(width: -250, height: 0) }
        }
    }
    
    private func startCrossingAnimation() {
        isCrossing = true
        
        withAnimation(.easeInOut(duration: 0.3).repeatForever(autoreverses: true)) {
            autoRotation = 10.0
        }
        
        withAnimation(.easeOut(duration: 0.4)) { biptyaOffset = bridgeEntrance }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.linear(duration: 10.0)) {
                biptyaOffset = CGSize(width: 850, height: -80)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            withAnimation {
                hasFinishedCrossing = true
                autoRotation = 0
            }
        }
    }
}
