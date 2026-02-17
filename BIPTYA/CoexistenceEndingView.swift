import SwiftUI
import Charts // The framework for data visualization

// MARK: - Data Models
struct LeopardData: Identifiable {
    let id = UUID()
    let year: Int
    let deaths: Int
}

struct CrossingData: Identifiable {
    let id = UUID()
    let year: Int
    let crossings: Int
}

struct CoexistenceEndingView: View {
    // --- State Management ---
    @State private var stage: Int = 0
    // 0: Title, 1: Background/Quote, 2: Mortality Graph, 3: Crossing Graph, 4: Final Overlay
    
    // --- Data Sets ---
    let mortalityData: [LeopardData] = [
        .init(year: 2012, deaths: 14), .init(year: 2013, deaths: 16),
        .init(year: 2014, deaths: 18), .init(year: 2015, deaths: 21),
        .init(year: 2016, deaths: 24), .init(year: 2017, deaths: 12),
        .init(year: 2018, deaths: 9), .init(year: 2019, deaths: 7),
        .init(year: 2020, deaths: 5)
    ]
    
    let crossingData: [CrossingData] = [
        .init(year: 2014, crossings: 38),
        .init(year: 2016, crossings: 52),
        .init(year: 2018, crossings: 74),
        .init(year: 2020, crossings: 91)
    ]

    var body: some View {
        ZStack {
            // Base layer: Black
            Color.black.ignoresSafeArea()
            
            // --- STAGE 1+: Background Image ---
            if stage >= 1 {
                Image("CoexistenceBackground") // Ensure this is in your Assets
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .overlay(Color.black.opacity(0.5)) // Darken to make text readable
                    .transition(.opacity)
                
                // Opening Quote
                if stage == 1 {
                    Text("“Progress is not just measured in kilometers of road,\nbut in lives safely preserved alongside it.”")
                        .font(.system(size: 24, weight: .medium, design: .serif))
                        .italic()
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(40)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            
            // --- STAGE 2 & 3: Data Visualization ---
            VStack(spacing: 30) {
                // Mortality Graph
                if stage == 2 {
                    VStack(alignment: .leading) {
                        Text("🐆 Leopard Mortality (Before vs After Mitigation)")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Chart(mortalityData) { item in
                            LineMark(
                                x: .value("Year", item.year),
                                y: .value("Deaths", item.deaths)
                            )
                            .interpolationMethod(.catmullRom)
                            .foregroundStyle(.orange)
                            .lineStyle(StrokeStyle(lineWidth: 3))
                            
                            PointMark(
                                x: .value("Year", item.year),
                                y: .value("Deaths", item.deaths)
                            )
                            .annotation(position: .top) {
                                Text("\(item.deaths)")
                                    .font(.caption2)
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(height: 250)
                        .chartXScale(domain: 2011...2021)
                        
                        Text("📍 NH7 – National Highway 44 Wildlife Corridor (Pench Landscape)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.black.opacity(0.8).cornerRadius(15))
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
                }
                
                // Crossing Data Graph
                if stage == 3 {
                    VStack(alignment: .leading) {
                        Text("Wildlife Crossings Per Month (Camera Trap Data)")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Chart(crossingData) { item in
                            BarMark(
                                x: .value("Year", String(item.year)),
                                y: .value("Crossings", item.crossings)
                            )
                            .foregroundStyle(Color.green.gradient)
                        }
                        .frame(height: 250)
                        
                        Text("Average crossings trending upwards following bridge infrastructure.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.black.opacity(0.8).cornerRadius(15))
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
                }
                
                // --- STAGE 4: Final Educational Overlay ---
                if stage == 4 {
                    VStack(spacing: 25) {
                        Text("“When roads slow down, forests breathe.”")
                            .italic()
                        Text("“Between 2016 and 2020, leopard deaths fell by over 75%.”")
                        Text("“Coexistence is not an idea. It is infrastructure.”")
                            .fontWeight(.black)
                    }
                    .font(.system(size: 20, design: .serif))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.black.opacity(0.85).cornerRadius(20))
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.orange.opacity(0.5), lineWidth: 1))
                    .transition(.move(edge: .bottom))
                }
            }
            .padding()

            // --- STAGE 0: Initial Title Card ---
            if stage == 0 {
                ZStack {
                    Color.black.ignoresSafeArea()
                    Text("ACT III: The Living Corridor")
                        .font(.system(size: 32, weight: .black, design: .serif))
                        .tracking(6)
                        .foregroundColor(.white)
                }
                .transition(.opacity)
            }
        }
        .onAppear {
            runEndingSequence()
        }
    }

    // Controls the timing of the cinematic sequence
    func runEndingSequence() {
        // Show Title, then transition to Background/Quote
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            withAnimation(.easeInOut(duration: 1.5)) { stage = 1 }
        }
        
        // Show the Mortality Line Graph
        DispatchQueue.main.asyncAfter(deadline: .now() + 8.5) {
            withAnimation(.easeInOut) { stage = 2 }
        }
        
        // Show the Crossing Bar Graph
        DispatchQueue.main.asyncAfter(deadline: .now() + 14.0) {
            withAnimation(.easeInOut) { stage = 3 }
        }
        
        // Final Summary Text
        DispatchQueue.main.asyncAfter(deadline: .now() + 19.5) {
            withAnimation(.spring(response: 1.0, dampingFraction: 0.8)) { stage = 4 }
        }
    }
}
