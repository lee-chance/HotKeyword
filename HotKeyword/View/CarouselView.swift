//
//  CarouselView.swift
//  HOT
//
//  Created by Changsu Lee on 2023/07/09.
//

import SwiftUI

struct CarouselView<Content: View, T: Any>: View {
    @Binding var selectedIndex: Int
    @State private var selectedTab: Int
    
    private let axis: Axis
    private let data: [T]
    private let realData: [T]
    private let content: (T) -> Content
    private let isInfinite: Bool
    private let transition: TransitionType
    
    // MARK: Init
    public init(axis: Axis = .vertical, data: [T], index: Binding<Int>, transition: TransitionType = .scale, isInfinite: Bool = true, @ViewBuilder content: @escaping (T) -> Content) {
        // We repeat the first and last element and add them to the data array. So we have something like this:
        // [item 4, item 1, item 2, item 3, item 4, item 1]
        var modifiedData = data
        if let firstElement = data.first, let lastElement = data.last, isInfinite {
            modifiedData.append(firstElement)
            modifiedData.insert(lastElement, at: 0)
            self.isInfinite = true
            self.selectedTab = index.wrappedValue + 1
        } else {
            self.isInfinite = false
            self.selectedTab = index.wrappedValue
        }
        self.axis = axis
        self.data = modifiedData
        self.realData = data
        self._selectedIndex = index
        self.content = content
        self.transition = transition
    }
    
    public var body: some View {
        GeometryReader { geometry in
            TabView(selection: $selectedTab) {
                /*
                 The data passed to ForEach is an array ([T]), but the actually data ForEach procesess is an array of tuples: [(1, data1),(2, data2), ...].
                 With this, we have the data and its corresponding index, so we don't have the problem of the same id, because the real index for ForEach is using for identify the items is the index generated with the zip function.
                 */
                ForEach(Array(zip(data.indices, data)), id: \.0) { index, item in
                    let positionMinX = geometry.frame(in: .global).minX
                    
                    content(item)
                        .if(axis == .vertical, transform: { view in
                            view
                                .rotationEffect(.degrees(-90)) // Rotate content
                                .frame(
                                    width: geometry.size.width,
                                    height: geometry.size.height
                                )
                        })
                        .rotation3DEffect(transition == .rotation3D ? getRotation(positionMinX) : .degrees(0), axis: (x: 0, y: 1, z: 0))
                        .opacity(transition == .opacity ? getValue(positionMinX) : 1)
                        .scaleEffect(transition == .scale ? getValue(positionMinX) : 1)
                        .tag(index)
                }
            }
            .if(axis == .vertical, transform: { view in
                view
                    .frame(
                        width: geometry.size.height, // Height & width swap
                        height: geometry.size.width
                    )
                    .rotationEffect(.degrees(90), anchor: .topLeading) // Rotate TabView
                    .offset(x: geometry.size.width) // Offset back into screens bounds
            })
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onChange(of: selectedIndex) { newValue in
                withAnimation {
                    selectedTab = newValue + 1
                }
            }
            .onChange(of: selectedTab) { newValue in
                if isInfinite {
                    // If the index is the first item (which is the last one, but repeated) we assign the tab to the real item, no the repeated one)
                    if newValue == 0 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            selectedTab = data.count - 2
                            selectedIndex = realData.count - 1
                        }
                    }
                    
                    // If the index is the last item (which is the first one, but repeated) we assign the tab to the real item, no the repeated one)
                    if newValue == data.count - 1 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            selectedTab = 1
                            selectedIndex = 0
                        }
                    }
                    
                    withAnimation {
                        selectedIndex = newValue - 1
                    }
                } else {
                    guard newValue < data.count else {
                        withAnimation {
                            selectedTab = 0
                            selectedIndex = 0
                        }
                        return
                    }
                    
                    withAnimation {
                        selectedIndex = newValue
                    }
                }
            }
        }
    }
}

// Helpers functions
extension CarouselView {
    // Get rotation for rotation3DEffect modifier
    private func getRotation(_ positionX: CGFloat) -> Angle {
        return .degrees(positionX / -10)
    }
    
    // Get the value for scale and opacity modifiers
    private func getValue(_ positionX: CGFloat) -> CGFloat {
        let scale = 1 - abs(positionX / UIScreen.main.bounds.width)
        return scale
    }
}

public enum TransitionType {
    case rotation3D, scale, opacity
}

struct CarouselView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselView(axis: .horizontal, data: [Color.red, .green, .blue], index: .constant(0), transition: .opacity, isInfinite: false) { item in
            item
                .frame(width: 100, height: 100)
                .cornerRadius(10)
        }
    }
}
