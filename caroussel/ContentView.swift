//
//  ContentView.swift
//  caroussel
//
//  Created by matthieu passerel on 18/12/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State var currentIndex: Int = 0
    let max = 8
    
    var body: some View {
        VStack {
            Text("Caroussel animé")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
                .foregroundStyle(.blue)
            GeometryReader { geometry in
                let size = geometry.size
                let imageHeight = size.height / 3
                let imageWidth = size.width * 0.66
                let frame = geometry.frame(in: .local)
                let midX = frame.midX
                let midY = frame.midY
                
                ZStack {
                    ForEach(0..<max, id: \.self) { index in
                        Image("chat_\(index)")
                            .resizable()
                            .scaledToFill()
                            .frame(width: imageWidth, height: imageHeight)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: .gray.opacity(0.75), radius: 4, x: 0, y: 4)
                            .position(x: midX, y: midY)
                            .scaleEffect(currentIndex == index ? 1.1: 0.5)
                            .opacity(currentIndex == index ? 1: 0.5)
                            .animation(.spring, value: currentIndex)
                            .offset(x: adjustOffset(index: index, initialSpacing: imageWidth / 2))
                            .zIndex(zIndex(index: index))
                            .swipe(
                                left: {
                                    self.currentIndex += 1
                                },
                                right: {
                                    self.currentIndex -= 1
                                }
                            )
                    }
                }
            }
            HStack {
                ForEach(0..<max, id: \.self) { index in
                    Circle()
                        .fill(currentIndex == index ? .blue : .gray)
                        .frame(width: 10, height: 10)
                        .scaleEffect(currentIndex == index ? 1.3 : 0.6)
                        .animation(.easeInOut(duration: 0.3), value: currentIndex)
                        .onTapGesture {
                            self.currentIndex = index
                        }
                }
            }
        }
        .padding()
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
                if currentIndex < max - 1 {
                    self.currentIndex += 1
                } else {
                    self.currentIndex = 0
                }
            }
        }
    }
    
    private func adjustOffset(index: Int, initialSpacing: CGFloat) -> CGFloat {
        let difference = index - currentIndex
        let spacing: CGFloat = 75
        
        if difference == 0 {
            return 0
        } else if difference > 0 {
            return CGFloat(difference) * spacing + initialSpacing
        } else {
            return CGFloat(difference) * spacing - initialSpacing
        }
    }
    
    private func zIndex(index: Int) -> Double {
        let diff = abs(index - currentIndex)
        let toDivide = diff + 1
        let calculation = Double(max) / Double(toDivide)
        return calculation
    }
}

#Preview {
    ContentView()
}

extension View {
    func swipe(
        up: @escaping (() -> Void) = {},
        down: @escaping (() -> Void) = {},
        left: @escaping (() -> Void) = {} ,
        right: @escaping (() -> Void) = {}
    ) -> some View {
        return self.gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onEnded({ value in
                if value.translation.width < 0 { left()}
                if value.translation.width > 0 { right()}
                if value.translation.height < 0 { up()}
                if value.translation.height > 0 { down()}
            }))
    }
}
