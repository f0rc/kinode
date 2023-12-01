

import Foundation


class DebouncedState: ObservableObject {
    @Published var currValue: String
    @Published var deValue: String
    
    init(initValue: String, delay: Double = 0.3) {
        _currValue = Published(initialValue: initValue)
        _deValue = Published(initialValue: initValue)
        
        $currValue
            .debounce(for: .seconds(delay), scheduler: RunLoop.main)
            .assign(to: &$deValue)
    }
}
