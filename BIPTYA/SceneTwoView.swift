//
//  SceneTwoView.swift
//  BIPTYA
//
//  Created by Nevin Abraham on 14/02/26.
//

//
//  SceneTwoView.swift
//  BIPTYA
//
//  Created by Nevin Abraham on 14/02/26.
//

import SwiftUI
import SpriteKit

struct SceneTwoView: View {
    
    // Passed from Scene 1
    let didBuildCorridor: Bool
    
    @State private var showChoices = false
    @State private var goToOutcome = false
    @State private var choseSafeCrossing = false
    
    // Create the SpriteKit scene for the Highway Mini-game
    var highwayGame: SKScene {
        let scene = HighwayScene()
        scene.size = CGSize(width: 400, height: 800)
        scene.scaleMode = .resizeFill
        return scene
    }
    
    var body: some View {
        ZStack {
            
            // MARK: - Dynamic Background
            Image(didBuildCorridor ? "Scene2WithBridge" : "Scene2EmptyHighway")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                
                // MARK: - Narrative Text
                Text("“The forest has changed. Hunger has not.”")
                    .font(.system(size: 30, weight: .medium, design: .serif))
                    .italic()
                    .foregroundColor(.white)
                    .padding(30)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(12)
                    .padding(.top, 100)
                
                Spacer()
                
                // MARK: - Choices
                if showChoices {
                    VStack(spacing: 20) {
                        
                        Text("How should Biptya cross?")
                            .font(.system(size: 40, weight: .bold, design: .serif))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        HStack(spacing: 20) {
                            
                            // OPTION A — Use Corridor
                            Button(action: {
                                choseSafeCrossing = true
                                goToOutcome = true
                            }) {
                                if didBuildCorridor {
                                    choiceButton(
                                        text: "USE CORRIDOR",
                                        color: .orange
                                    )
                                } else {
                                    choiceButton(
                                        text: "LOCKED",
                                        color: .gray
                                    )
                                    .opacity(0.6)
                                }
                            }
                            .disabled(!didBuildCorridor)
                            
                            // OPTION B — Cross Highway
                            Button(action: {
                                choseSafeCrossing = false
                                goToOutcome = true
                            }) {
                                choiceButton(
                                    text: "CROSS HIGHWAY",
                                    color: .orange
                                )
                            }
                        }
                    }
                    .padding(.bottom, 200)
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .bottom)
                                .combined(with: .opacity),
                            removal: .opacity
                        )
                    )
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        
        // MARK: - Delayed cinematic reveal
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeOut(duration: 0.8)) {
                    showChoices = true
                }
            }
        }
        
        // MARK: - Navigation to Outcome
        .navigationDestination(isPresented: $goToOutcome) {
            if choseSafeCrossing {
                CorridorCrossingView()
            } else {
                // MARK: - SpriteKit Action Scene
                // This displays the high-performance car-dodging game
                SpriteView(scene: highwayGame)
                    .ignoresSafeArea()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

// MARK: - Reusable Cinematic Button Style
extension SceneTwoView {
    func choiceButton(text: String, color: Color) -> some View {
        Text(text)
            .font(.system(size: 20, weight: .bold))
            .tracking(1.5)
            .frame(width: 200, height: 80)
            .background(color.opacity(0.85))
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(color: color.opacity(0.4), radius: 10)
    }
}
