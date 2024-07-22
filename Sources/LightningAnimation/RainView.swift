//
// 
// SwiftUIView.swift
//
// Created by Reyna Myers on 22/7/24
//
// Copyright ©2024 DoorHinge Apps.
//


import SwiftUI

public struct Rain: View {
    @State private var raindrops: [Raindrop] = []
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    public init() {}
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                ForEach(raindrops) { drop in
                    RaindropView(drop: drop, screenHeight: proxy.size.height)
                        .animation(.linear(duration: drop.duration))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + drop.duration) {
                                raindrops.removeAll { $0.id == drop.id }
                            }
                        }
                }
            }
            .onReceive(timer) { _ in
                raindrops.append(Raindrop())
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct Raindrop: Identifiable {
    let id = UUID()
    let xPos: CGFloat
    let duration: Double

    init() {
        xPos = CGFloat.random(in: 0..<UIScreen.main.bounds.width)
        duration = Double.random(in: 0.5...2)
    }
}

struct RaindropView: View {
    let drop: Raindrop
    let screenHeight: CGFloat
    
    @State private var progress: CGFloat = 0
    
    var body: some View {
        DropShape(progress: progress)
            .frame(width: 2, height: 20)
            .foregroundColor(Color(hex: "C7C7C7"))
            .opacity(0.85)
            .position(x: drop.xPos, y: progress * screenHeight)
            .onAppear {
                withAnimation(.linear(duration: drop.duration)) {
                    progress = 1
                }
            }
    }
}

struct DropShape: Shape {
    var progress: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRoundedRect(in: rect, cornerSize: CGSize(width: 5, height: 5))
        return path
    }
    
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
}
