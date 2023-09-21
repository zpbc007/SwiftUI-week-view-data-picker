import ComposableArchitecture
import SwiftUI

struct MyTestFeature: Reducer {
    struct State: Equatable {
        var count = 0
    }
    
    enum Action: Equatable {
        case add
        case minus
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .add:
            state.count += 1
            return .none
        case .minus:
            state.count -= 1
            return .none
        }
    }
}

public struct MyTestView: View {
    let store: StoreOf<MyTestFeature>
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Text("count: \(viewStore.count)")
                HStack {
                    Button("-") {
                        viewStore.send(.minus)
                    }
                    Button("+") {
                        viewStore.send(.add)
                    }
                }
            }
            
        }
    }
}


struct MyTestView_Previews: PreviewProvider {
    static var previews: some View {
        MyTestView(store: Store(initialState: MyTestFeature.State(), reducer: {
            MyTestFeature()
        }))
    }
}
