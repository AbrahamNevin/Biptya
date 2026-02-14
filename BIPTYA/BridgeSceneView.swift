import SwiftUI

struct BridgeSceneView: View {
    let didChooseCorridor: Bool // Data passed from Scene One
    
    @State private var goToSceneTwo = false
    @State private var dragOffset: CGSize = CGSize(width: 0, height: -250)
    @State private var isPlaced: Bool = false
    @State private var showNextButton: Bool = false
    
    let targetLocation = CGSize(width: 120, height: -90)
    let snapTolerance: CGFloat = 50.0
    let biptyaColor = Color(red: 181/255, green: 103/255, blue: 13/255)
    
    var body: some View {
        ZStack {
            // --- DYNAMIC BACKGROUND ---
            // If corridor chosen: show game bg. If speed chosen: show speed bg.
            Image(didChooseCorridor ? "Scene1Base" : "ConstructionSpedUpBG")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .opacity(didChooseCorridor ? (isPlaced ? 1.0 : 0.6) : 1.0)
                .animation(.easeInOut(duration: 1.0), value: isPlaced)
            
            VStack {
                // Instruction/Feedback Box
                Text(didChooseCorridor ?
                     (isPlaced ? "WAY SECURED" : "DRAG THE CORRIDOR TO THE HIGHWAY") :
                     "CONSTRUCTION SPED UP")
                    .font(.system(size: 16, weight: .black))
                    .tracking(2)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(8)
                    .padding(.top, 380)
                
                if !didChooseCorridor {
                    Text("The highway is completed ahead of schedule.\nNo safety measures were installed.")
                        .font(.system(size: 18, weight: .medium, design: .serif))
                        .italic()
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.4))
                        .cornerRadius(10)
                        .padding(.top, 20)
                }
                
                Spacer()
                
                // Show button if game is finished OR if player chose "Speed"
                if showNextButton || !didChooseCorridor {
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
            
            // --- INTERACTIVE ELEMENTS (Only if Corridor was chosen) ---
            if didChooseCorridor {
                if !isPlaced {
                    Image("bridge") // Ghost Guide
                        .resizable()
                        .scaledToFit()
                        .frame(width: 1000)
                        .opacity(0.2)
                        .offset(targetLocation)
                }
                
                Image("bridge") // Draggable Bridge
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
                    .animation(.spring(response: 0.5, dampingFraction: 0.7), value: dragOffset)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $goToSceneTwo) {
            // Navigate to Scene Two and pass the data forward
            SceneTwoView(didBuildCorridor: didChooseCorridor)
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
