import Foundation
import Redux

class CounterStore: Publisher, Dispatch {
    private let store = Store<CounterState>(initialState: CounterState()) { state, action in
        switch action {
        case let action as CounterIncrementAction:
            return CounterState(counter: state.counter + action.increment)

        default:
            return state
        }
    }

    func subscribe(subscription: CounterState -> Void) -> Void -> Void {
        return store.subscribe(subscription)
    }

    func dispatch(action: Action) {
        return store.dispatch(action)
    }
}

struct CounterState {
    let counter: Int

    init (counter: Int = 0) {
        self.counter = counter
    }
}

struct CounterIncrementAction: Action {
    let increment: Int
}

class CounterSubscriber: Subscriber, StateConnectable {
    private(set) var counter: Int
    private(set) var connection: StateConnection?

    init (counter: Int) {
        self.counter = counter
    }

    func select(publishing: CounterState) -> Int {
        return publishing.counter
    }

    func receive(selection: Int) {
        self.counter = selection
    }

    func connect(with connection: StateConnection) {
        self.connection = connection
    }
}
