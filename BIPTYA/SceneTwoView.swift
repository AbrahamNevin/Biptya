//
//  SceneTwoView.swift
//  BIPTYA
//
//  Created by Nevin Abraham on 14/02/26.
//

import SwiftUI

struct SceneTwoView: View {
    
    // Passed from Scene 1
    let didBuildCorridor: Bool
    
    @State private var showChoices = false
    @State private var goToOutcome = false
    @State private var choseSafeCrossing = false
    
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
                            .foregroundColor(.white)
                        
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
//            SceneTwoOutcomeView(
//                didChooseSafePath: choseSafeCrossing,
//                corridorExists: didBuildCorridor
//            )
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
