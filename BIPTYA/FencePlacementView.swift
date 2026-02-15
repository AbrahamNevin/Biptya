import SwiftUI

struct FencePlacementView: View {
    @State private var goToNextScene = false
    
    // State for Fence 1 (Left)
    @State private var dragOffset1: CGSize = CGSize(width: -100, height: -300)
    @State private var isPlaced1 = false
    
    // State for Fence 2 (Right)
    @State private var dragOffset2: CGSize = CGSize(width: 100, height: -300)
    @State private var isPlaced2 = false
    
    @State private var showNextButton = false
    
    // --- SETTINGS ---
    // Left Fence
    let target1 = CGSize(width: -350, height: 250)
    let degrees1: Double = -10.0
    let width1: CGFloat = 800.0  // Keep the left one large
    
    // Right Fence
    let target2 = CGSize(width: 350, height: 120)
    let degrees2: Double = 0.0
    let width2: CGFloat = 600.0  // DECREASED size for the right one
    
    let snapTolerance: CGFloat = 60.0
    let biptyaColor = Color(red: 181/255, green: 103/255, blue: 13/255)

    var body: some View {
        ZStack {
            Image("FenceBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            // 2. Target Outlines
            Group {
                if !isPlaced1 {
                    targetShadow(imageName: "fence_left", at: target1, degrees: degrees1, width: width1)
                }
                if !isPlaced2 {
                    targetShadow(imageName: "fence_right", at: target2, degrees: degrees2, width: width2)
                }
            }

            // 3. Draggable Fences
            fenceItem(imageName: "fence_left", offset: $dragOffset1, isPlaced: isPlaced1, target: target1, degrees: degrees1, width: width1) {
                checkPlacement(for: 1)
            }
            
            fenceItem(imageName: "fence_right", offset: $dragOffset2, isPlaced: isPlaced2, target: target2, degrees: degrees2, width: width2) {
                checkPlacement(for: 2)
            }

            // UI Overlay
            VStack {
                Text(isPlaced1 && isPlaced2 ? "PERIMETER SECURED" : "DRAG THE FENCES TO PROTECT THE VILLAGE")
                    .font(.system(size: 16, weight: .black))
                    .tracking(2)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(8)
                    .padding(.top, 60)
                
                Spacer()
                
                if showNextButton {
                    Button(action: { goToNextScene = true }) {
                        Text("CONTINUE")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 15)
                            .background(biptyaColor)
                            .cornerRadius(10)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 50)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Helper Views
    
    // Added 'width' parameter
    func targetShadow(imageName: String, at pos: CGSize, degrees: Double, width: CGFloat) -> some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: width) // Use the individual width
            .rotationEffect(.degrees(degrees))
            .opacity(0.2)
            .offset(pos)
    }

    // Added 'width' parameter
    func fenceItem(imageName: String, offset: Binding<CGSize>, isPlaced: Bool, target: CGSize, degrees: Double, width: CGFloat, onEnd: @escaping () -> Void) -> some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: width) // Use the individual width
            .rotationEffect(.degrees(degrees))
            .shadow(color: .black.opacity(isPlaced ? 0 : 0.4), radius: 10)
            .offset(offset.wrappedValue)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if !isPlaced {
                            offset.wrappedValue = CGSize(
                                width: value.translation.width + (pieceInitialWidth(for: imageName)),
                                height: value.translation.height + (-300)
                            )
                        }
                    }
                    .onEnded { _ in onEnd() }
            )
            .animation(.spring(), value: offset.wrappedValue)
    }
    
    func pieceInitialWidth(for name: String) -> CGFloat {
        return name == "fence_left" ? -100 : 100
    }

    // MARK: - Logic
    
    func checkPlacement(for piece: Int) {
        if piece == 1 {
            if isNear(dragOffset1, target1) {
                withAnimation(.spring()) {
                    dragOffset1 = target1
                    isPlaced1 = true
                }
            } else {
                withAnimation(.spring()) { dragOffset1 = CGSize(width: -100, height: -300) }
            }
        } else {
            if isNear(dragOffset2, target2) {
                withAnimation(.spring()) {
                    dragOffset2 = target2
                    isPlaced2 = true
                }
            } else {
                withAnimation(.spring()) { dragOffset2 = CGSize(width: 100, height: -300) }
            }
        }
        
        if isPlaced1 && isPlaced2 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation { showNextButton = true }
            }
        }
    }
    
    func isNear(_ current: CGSize, _ target: CGSize) -> Bool {
        let xDist = abs(current.width - target.width)
        let yDist = abs(current.height - target.height)
        return xDist < snapTolerance && yDist < snapTolerance
    }
}
