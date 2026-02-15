import SwiftUI
import SpriteKit

struct SceneTwoView: View {
    let didChooseCorridor: Bool
    
    @State private var showChoices = false
    @State private var goToOutcome = false
    @State private var choseSafeCrossing = false
    
    // NEW: State to trigger navigation to the Fence Placement screen
    @State private var goToFenceBuild = false
    
    var highwayGame: SKScene {
        // Updated to use full screen bounds and resizeFill to prevent zooming
        let scene = HighwayScene(size: UIScreen.main.bounds.size)
        scene.didChooseCorridor = self.didChooseCorridor
        scene.scaleMode = .resizeFill
        return scene
    }
    
    var body: some View {
        ZStack {
            Image(didChooseCorridor ? "Scene2WithBridge" : "Scene2EmptyHighway")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                Text("“The forest has changed. Hunger has not.”")
                    .font(.system(size: 30, weight: .medium, design: .serif))
                    .italic()
                    .foregroundColor(.white)
                    .padding(30)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(12)
                    .padding(.top, 100)
                
                Spacer()
                
                if showChoices {
                    VStack(spacing: 20) {
                        Text("How should Biptya cross?")
                            .font(.system(size: 40, weight: .bold, design: .serif))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 20) {
                            Button(action: {
                                choseSafeCrossing = true
                                goToOutcome = true
                            }) {
                                choiceButton(text: didChooseCorridor ? "USE CORRIDOR" : "LOCKED",
                                             color: didChooseCorridor ? .orange : .gray)
                            }
                            .disabled(!didChooseCorridor)
                            
                            Button(action: {
                                choseSafeCrossing = false
                                goToOutcome = true
                            }) {
                                choiceButton(text: "CROSS HIGHWAY", color: .orange)
                            }
                        }
                    }
                    .padding(.bottom, 200)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        // Listener for the Fence Placement screen
        .navigationDestination(isPresented: $goToFenceBuild) {
            FencePlacementView()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation { showChoices = true }
            }
        }
        .navigationDestination(isPresented: $goToOutcome) {
            if choseSafeCrossing {
                CorridorCrossingView()
            } else {
                // The SpriteKit view wrapper
                SpriteView(scene: highwayGame)
                    .ignoresSafeArea()
                    .navigationBarBackButtonHidden(true)
                    // KEY: This listens for the message from InjuredScene
                    .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("GoToFenceBuild"))) { _ in
                        print("SwiftUI: Transitioning to Fence Scene")
                        self.goToFenceBuild = true
                    }
            }
        }
    }
    
    func choiceButton(text: String, color: Color) -> some View {
        Text(text)
            .font(.system(size: 20, weight: .bold))
            .frame(width: 200, height: 80)
            .background(color.opacity(0.85))
            .foregroundColor(.white)
            .cornerRadius(12)
    }
}
