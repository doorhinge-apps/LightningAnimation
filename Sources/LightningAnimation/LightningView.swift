//
// 
// SwiftUIView.swift
//
// Created by Reyna Myers on 22/7/24
//
// Copyright ©2024 DoorHinge Apps.
//


import SwiftUI


public struct LightningBolt: View {
    @State private var trigger: CGFloat = 0
    @State private var time: CGFloat = 0
    let timer = Timer.publish(every: 0.005, on: .main, in: .common).autoconnect()
    @State private var mainPath: Path = Path()
    @State private var branches: [Path] = []
    @State private var branchPoints: [CGPoint] = []
    
    @State var pauseAnimating = false
    
    @State var brighterLightning = false
    
    @State var lightningOpacity = false

    public var body: some View {
        ZStack {
            ForEach(branches.indices, id: \.self) { index in
                branches[index]
                    .stroke(Color.white, lineWidth: brighterLightning ? 3: 2)
                    .shadow(color: Color.white.opacity(0.5), radius: 10, x: 0, y: 0)
                    .shadow(color: Color.white, radius: brighterLightning ? 10: 0, x: 0, y: 0)
                    .shadow(color: Color.white, radius: brighterLightning ? 10: 0, x: 0, y: 0)
                    .shadow(color: Color.blue.opacity(0.5), radius: 10, x: 0, y: 0)
                    .shadow(color: Color.white, radius: brighterLightning ? 10: 0, x: 0, y: 0)
                    .shadow(color: Color.blue, radius: brighterLightning ? 10: 0, x: 0, y: 0)
                    .opacity(lightningOpacity ? 0.0: 1.0)
            }
            
            mainPath
                .stroke(Color.white, lineWidth: brighterLightning ? 3: 2)
                .shadow(color: Color.white.opacity(0.5), radius: 10, x: 0, y: 0)
                .shadow(color: Color.white, radius: brighterLightning ? 10: 0, x: 0, y: 0)
                .shadow(color: Color.white, radius: brighterLightning ? 10: 0, x: 0, y: 0)
                .shadow(color: Color.blue.opacity(0.5), radius: 10, x: 0, y: 0)
                .shadow(color: Color.white, radius: brighterLightning ? 10: 0, x: 0, y: 0)
                .shadow(color: Color.blue, radius: brighterLightning ? 10: 0, x: 0, y: 0)
                .opacity(lightningOpacity ? 0.0: 1.0)
            
            .onReceive(timer) { _ in
                if !pauseAnimating {
                    self.time += 0.02
                    
                    if self.time >= 1 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                            withAnimation(.bouncy(duration: 0.2, extraBounce: 0.0)) {
                                brighterLightning = true
                            }
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation(.linear(duration: 0.2)) {
                                lightningOpacity = true
                            }
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            pauseAnimating = true
                            self.time = 0
                            self.trigger += 1
                            
                            mainPath = Path { path in
                                path.move(to: CGPoint(x: UIScreen.main.bounds.midX, y: 0))
                            }
                            branches = []
                            branchPoints = []
                            
                            brighterLightning = false
                            lightningOpacity = false
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            pauseAnimating = false
                        }
                    } else {
                        self.updatePath()
                    }
                }
            }
        }
    }
    
    func updatePath() {
        guard let lastPoint = mainPath.currentPoint else { return }
        let rect = UIScreen.main.bounds
        let xRange: CGFloat = (lastPoint.y < rect.midY) ? 15 : 30
        let yIncrement = CGFloat.random(in: 15...30)
        
        let newX = lastPoint.x + CGFloat.random(in: -xRange...xRange)
        let newY = min(lastPoint.y + yIncrement, rect.height)
        let newPoint = CGPoint(x: newX, y: newY)

        mainPath.addLine(to: newPoint)  // Update the main lightning path
        
        // Add to list of potential branching points
        branchPoints.append(newPoint)

        // Occasionally add a branch from a random point with reduced frequency
        if Bool.random(probability: 0.1) && branchPoints.count > 2 && newY < rect.height * 0.85 {
            let branchOriginIndex = Int.random(in: 0..<branchPoints.count)
            addBranch(from: branchPoints[branchOriginIndex], mainBoltPoint: lastPoint)
        }
    }
    
    func addBranch(from startPoint: CGPoint, mainBoltPoint: CGPoint) {
        var newPath = Path()
        newPath.move(to: startPoint)
        
        var branchPoint = startPoint
        let branchLength = CGFloat.random(in: 60...150)
        let branchSteps = Int(branchLength / 10)
        let direction = (startPoint.x < mainBoltPoint.x) ? -1 : 1
        
        for _ in 0..<branchSteps {
            let branchX = branchPoint.x + CGFloat.random(in: 5...30) * CGFloat(direction)
            let branchY = branchPoint.y + CGFloat.random(in: 10...20)
            branchPoint = CGPoint(x: branchX, y: branchY)
            newPath.addLine(to: branchPoint)
        }
        
        branches.append(newPath)
    }
}
