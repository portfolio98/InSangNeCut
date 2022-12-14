//final class OneDayViewController: UIViewController, View {
//    typealias Reactor = OneDayReactor
//    var disposeBag = DisposeBag()
//
//    func bind(reactor: Reactor) {
//        dispatch(reactor: reactor)
//        render(reactor: reactor)
//    }
//
//    private func dispatch(reactor: Reactor) {
//        disposeBag.insert {
//
//        }
//    }
//
//    private func render(reactor: Reactor) {
//        disposeBag.insert {
//
//        }
//    }
//
//    // MARK: - Initialize
//    init(reactor: Reactor) {
//        super.init(nibName: nil, bundle: nil)
//        self.reactor = reactor
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // MARK: - UIComponents
//    lazy var imageView: UIImageView = {
//
//        return $0
//    }(UIImageView())
//
//}
//
//class OneDayReactor: Reactor {
//    enum Action {
//
//    }
//
//    enum Mutation {
//
//    }
//
//    struct State {
//
//    }
//
//    var initialState: State
//    init(initialState: State) {
//        self.initialState = initialState
//    }
//
//    func mutate(action: Action) -> Observable<Mutation> {
//        switch action {
//
//        }
//    }
//
//    func reduce(state: State, mutation: Mutation) -> State {
//        var newState = state
//        switch mutation {
//
//        }
//    }
//}
