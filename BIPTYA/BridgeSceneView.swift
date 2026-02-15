import SwiftUI

struct BridgeSceneView: View {
    let didChooseCorridor: Bool
    
    @State private var goToSceneTwo = false
    @State private var dragOffset: CGSize = CGSize(width: 0, height: -250)
    @State private var isPlaced: Bool = false
    @State private var showNextButton: Bool = false
    
    // --- STATE FOR SLIDER GAME ---
    @State private var sliderValue: Double = 0.0
    
    let targetLocation = CGSize(width: 120, height: -90)
    let snapTolerance: CGFloat = 50.0
    let biptyaColor = Color(red: 181/255, green: 103/255, blue: 13/255)
    
    var body: some View {
        ZStack {
            // --- DYNAMIC BACKGROUND (Smooth Cross-fade) ---
            if didChooseCorridor {
                Image(isPlaced ? "Scene1Base" : "ConstructionSpedUpBG")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .opacity(isPlaced ? 1.0 : 0.6)
            } else {
                // Smoothly fading layers
                ZStack {
                    Image("Road_Phase1")
                        .resizable()
                        .scaledToFill()
                        .opacity(1.0)
                    
                    Image("Road_Phase2")
                        .resizable()
                        .scaledToFill()
                        // Fade in phase 2 between 20% and 60%
                        .opacity(max(0, min(1, (sliderValue - 20) / 40)))
                    
                    Image("Road_Phase3")
                        .resizable()
                        .scaledToFill()
                        // Fade in phase 3 between 60% and 100%
                        .opacity(max(0, min(1, (sliderValue - 60) / 40)))
                }
                .ignoresSafeArea()
            }
            
            // --- EXCAVATOR (Randomized X and Y Jitter) ---
//            if !didChooseCorridor {
//                Image("excavator")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 600)
//                    // X moves with slider + jitter; Y wobbles using a sine wave
//                    .offset(
//                        x: -300 + (CGFloat(sliderValue) * 4) + CGFloat(sin(sliderValue * 0.5) * 10),
//                        y: 100 + CGFloat(cos(sliderValue * 0.8) * 15)
//                    )
//                    .animation(.interactiveSpring(), value: sliderValue)
//            }
            // --- EXCAVATOR (Moving Top to Bottom) ---
            if !didChooseCorridor {
                Image("excavator")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 600)
                    .offset(
                        // Horizontal Jitter (vibrating while working)
                        x: CGFloat(sin(sliderValue * 0.5) * 10),
                        
                        // Starts at -300 (Top) and moves to 300 (Bottom)
                        // As sliderValue goes 0 -> 100, Y goes -300 -> +300
                        y: -150 + (CGFloat(sliderValue) * 2) + CGFloat(cos(sliderValue * 0.8) * 15)
                    )
                    .animation(.interactiveSpring(), value: sliderValue)
            }
            
            VStack {
                // Instruction Box
                Text(didChooseCorridor ?
                     (isPlaced ? "WAY SECURED" : "DRAG THE CORRIDOR TO THE HIGHWAY") :
                     (sliderValue >= 100 ? "CONSTRUCTION COMPLETE" : "SLIDE TO SPEED UP CONSTRUCTION"))
                    .font(.system(size: 16, weight: .black))
                    .tracking(2)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(8)
                    .padding(.top, 50)
                
                if !didChooseCorridor && sliderValue >= 100 {
                    Text("The highway is completed ahead of schedule.\nNo safety measures were installed.")
                        .font(.system(size: 18, weight: .medium, design: .serif))
                        .italic()
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.4))
                        .cornerRadius(10)
                }
                
                Spacer()
                
                // --- SLIDER ---
//                if !didChooseCorridor && !showNextButton {
//                    VStack {
//                        Slider(value: $sliderValue, in: 0...100, step: 0.5) // Step 0.5 for smoother movement
//                            .accentColor(biptyaColor)
//                            .padding(.horizontal, 40)
//                            .onChange(of: sliderValue) { newValue in
//                                if newValue >= 100 {
//                                    withAnimation { showNextButton = true }
//                                }
//                            }
//                        Text("\(Int(sliderValue))% COMPLETE")
//                            .font(.caption)
//                            .foregroundColor(.white)
//                            .bold()
//                    }
//                    .padding(.bottom, 100)
//                }
                // --- SHORTENED SLIDER ---
                if !didChooseCorridor && !showNextButton {
                    VStack {
                        Slider(value: $sliderValue, in: 0...100, step: 0.5)
                            .accentColor(biptyaColor)
                            .frame(width: 500) // Set this to your preferred length (e.g., 150, 200, 250)
                            .onChange(of: sliderValue) { newValue in
                                if newValue >= 100 {
                                    withAnimation { showNextButton = true }
                                }
                            }
                        
                        Text("\(Int(sliderValue))% COMPLETE")
                            .font(.caption)
                            .foregroundColor(.white)
                            .bold()
                    }
                    .padding(.bottom, 100)
                }
                
                // --- CONTINUE BUTTON ---
                if showNextButton {
                    Button(action: { goToSceneTwo = true }) {
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
            
            if didChooseCorridor {
                corridorDragLogic
            }
        }
        .navigationBarBackButtonHidden(true)
        // Change this line:
        .navigationDestination(isPresented: $goToSceneTwo) {
            SceneTwoView(didChooseCorridor: didChooseCorridor) // Use didChooseCorridor here
        }
    }
    
    private var corridorDragLogic: some View {
        Group {
            if !isPlaced {
                Image("bridge")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 1000)
                    .opacity(0.2)
                    .offset(targetLocation)
            }
            
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
                        .onEnded { _ in checkPlacement() }
                )
        }
    }
    
    private func checkPlacement() {
        let xDist = abs(dragOffset.width - targetLocation.width)
        let yDist = abs(dragOffset.height - targetLocation.height)
        
        if xDist < snapTolerance && yDist < snapTolerance {
            withAnimation(.spring()) {
                dragOffset = targetLocation
                isPlaced = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation { showNextButton = true }
            }
        } else {
            withAnimation(.spring()) {
                dragOffset = CGSize(width: 0, height: -250)
            }
        }
    }
}
