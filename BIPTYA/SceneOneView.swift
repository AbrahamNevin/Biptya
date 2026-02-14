import SwiftUI

struct SceneOneView: View {
    
    @State private var storyPhase = 0 // 0: Title, 1: Sequential Text, 2: Choices
    @State private var lineVisible = [false, false, false, false]
    @State private var showContinueButton = false
    @State private var goToBridgeScene = false // Navigation trigger
    
    let biptyaColor = Color(red: 181/255, green: 103/255, blue: 13/255)
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            // --- BACKGROUND IMAGE ---
            if storyPhase >= 1 {
                Image("Scene1Base")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .opacity(storyPhase == 1 ? 0.3 : 0.6)
                    .transition(.opacity.animation(.easeInOut(duration: 2)))
            }
            
            // --- PHASE 0: ACT 1 TITLE ---
            if storyPhase == 0 {
                Text("ACT 1: The Divided Path")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation { storyPhase = 1 }
                        }
                    }
            }
            
            // --- PHASE 0: ACT 1 TITLE ---
             if storyPhase == 0 {
                 Text("ACT 1: The Divided Path")
                     .font(.system(size: 48, weight: .bold))
                     .foregroundColor(.white)
                     .onAppear {
                         DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                             withAnimation { storyPhase = 1 }
                         }
                     }
             }
             
             // --- PHASE 1: SEQUENTIAL NARRATIVE TEXT ---
             if storyPhase == 1 {
                 VStack(alignment: .leading, spacing: 25) {
                     if lineVisible[0] {
                         Text("Highways are rising across rural Maharashtra, cutting through endless sugarcane fields where Biptyas silently move at dusk.")
                             .transition(.opacity.combined(with: .move(edge: .bottom)))
                     }
                     
                     if lineVisible[1] {
                         Text("Construction promises progress — but it also fragments their hidden pathways, pushing them closer to human settlements.")
                             .transition(.opacity.combined(with: .move(edge: .bottom)))
                     }
                     
                     if lineVisible[2] {
                         Text("Dust settles. Machines pause. A leopard watches from the cane.")
                             .transition(.opacity.combined(with: .move(edge: .bottom)))
                     }
                     
                     if lineVisible[3] {
                         Text("Will you build for speed… or for coexistence?")
                             .foregroundColor(biptyaColor)
                             .fontWeight(.bold)
                             .transition(.opacity.combined(with: .move(edge: .bottom)))
                     }
                     
                     if showContinueButton {
                         Button(action: {
                             withAnimation { storyPhase = 2 }
                         }) {
                             Text("CONTINUE")
                                 .font(.system(size: 14, weight: .black))
                                 .tracking(2)
                                 .foregroundColor(biptyaColor)
                                 .padding(.top, 20)
                         }
                         .transition(.opacity)
                     }
                 }
                 .font(.system(size: 22, weight: .medium, design: .serif))
                 .italic()
                 .foregroundColor(.white)
                 .padding(60)
                 .onAppear {
                     revealLinesSequentially()
                 }
             }
            
            // --- PHASE 2: THE CHOICES ---
            if storyPhase == 2 {
                VStack {
                    Spacer()
                    HStack(spacing: 30) {
                        // Choice A: Navigate to the Interactive Bridge Scene
                        Button(action: { goToBridgeScene = true }) {
                            choiceButton(text: "BUILD WILDLIFE CORRIDOR", color: .orange)
                        }
                        
                        // Choice B: This could navigate to a different scene later
                        Button(action: { goToBridgeScene = true }) {
                            choiceButton(text: "SPEED UP CONSTRUCTION", color: .orange)
                        }
                    }
                    .padding(.bottom, 80)
                }
                .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity), removal: .opacity))
            }
        }
        .navigationBarBackButtonHidden(true)
        // This is where you connect the two screens
        .navigationDestination(isPresented: $goToBridgeScene) {
            BridgeSceneView()
        }
    }
    
    private func revealLinesSequentially() {
        for i in 0..<4 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 1.5) {
                withAnimation(.easeOut(duration: 1.0)) {
                    lineVisible[i] = true
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            withAnimation {
                showContinueButton = true
            }
        }
    }
    
    func choiceButton(text: String, color: Color) -> some View {
        Text(text)
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .frame(width: 280, height: 80)
            .background(Color.black.opacity(0.8))
            .cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(color, lineWidth: 2))
    }
}
