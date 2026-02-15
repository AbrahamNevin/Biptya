import SwiftUI
import SpriteKit

struct SceneTwoView: View {
    let didChooseCorridor: Bool
    
    @State private var showChoices = false
    @State private var goToOutcome = false
    @State private var choseSafeCrossing = false
    
    var highwayGame: SKScene {
        // 1. Get the actual screen size if possible, or use a flexible approach
        let scene = HighwayScene(size: UIScreen.main.bounds.size)
        scene.didChooseCorridor = self.didChooseCorridor
        scene.scaleMode = .resizeFill // 2. Change this to resizeFill
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
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation { showChoices = true }
            }
        }
        .navigationDestination(isPresented: $goToOutcome) {
            if choseSafeCrossing {
                // REPLACE the Text placeholder with your actual View
                CorridorCrossingView()
            } else {
                SpriteView(scene: highwayGame)
                    .ignoresSafeArea()
                    .navigationBarBackButtonHidden(true)
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
