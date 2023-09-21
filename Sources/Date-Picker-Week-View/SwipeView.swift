//
//  SwiftUIView.swift
//  
//
//  Created by zhaopeng on 2023/9/21.
//

import SwiftUI

enum SwipeDirection {
    case left
    case right
    case unknown
}

enum SwipeTabIndex: Int, Equatable {
    case left = 0
    case center = 1
    case right = 2
}

struct SwipeView<Content: View>: View {
    @State private var activeTab: SwipeTabIndex = .center
    @State private var direction: SwipeDirection = .unknown
    
    var contentBuilder: (_ tabIndex: SwipeTabIndex) -> Content
    var onSwipe: (_ direction: SwipeDirection) -> Void
    
    init(
        onSwipe: @escaping (_ direction: SwipeDirection) -> Void,
        @ViewBuilder contentBuilder: @escaping (SwipeTabIndex) -> Content
    ) {
        self.onSwipe = onSwipe
        self.contentBuilder = contentBuilder
    }
    
    var body: some View {
        TabView(selection: $activeTab) {
            contentBuilder(SwipeTabIndex.left)
                .frame(maxWidth: .infinity)
                .tag(SwipeTabIndex.left)
            
            contentBuilder(SwipeTabIndex.center)
                .frame(maxWidth: .infinity)
                .onDisappear() {
                    guard direction != .unknown else { return }
                    // 通知外部
                    onSwipe(direction)
                    direction = .unknown
                    // 继续显示中间内容
                    activeTab = .center
                }
                .tag(SwipeTabIndex.center)
            
            contentBuilder(SwipeTabIndex.right)
                .frame(maxWidth: .infinity)
                .tag(SwipeTabIndex.right)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onChange(of: activeTab) { newValue in
            if newValue == .left {
                direction = .left
            } else if (newValue == .right) {
                direction = .right
            }
        }
    }
}

struct WeekTabView_Previews: PreviewProvider {
    struct TestArraryView: View {
        var value: Int
        
        var body: some View {
            HStack {
                Text("\(value)--\(value)")
                    .frame(height: 30)
                    .background(.green)
                    .padding()
                
                Text("\(value + 1)--\(value)")
                    .frame(height: 30)
                    .background(.green)
                    .padding()
                
                Text("\(value + 2)--\(value)")
                    .frame(height: 30)
                    .background(.green)
                    .padding()
            }
        }
    }

    struct TestWeekTabView: View {
        @State var centerValue = 5

        var body: some View {
            SwipeView { newDirection in
                if newDirection == .left {
                    self.centerValue -= 3
                }
                if newDirection == .right {
                    self.centerValue += 3
                }
            } contentBuilder: { tabIndex in
                VStack {
                    Text("Center value: \(centerValue)")
                    
                    if tabIndex == .left {
                        TestArraryView(value: centerValue - 3)
                    }
                    
                    if tabIndex == .center {
                        TestArraryView(value: centerValue)
                    }

                    if tabIndex == .right {
                        TestArraryView(value: centerValue + 3)
                    }
                }
                
            }
        }
    }
    static var previews: some View {
        VStack {
            Text("22")
            TestWeekTabView()
        }
    }
}
