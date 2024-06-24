import Foundation
import Network

class Reachability {
    static let shared = Reachability()
    private var monitor: NWPathMonitor
    private var queue: DispatchQueue

    private init() {
        monitor = NWPathMonitor()
        queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
    }

    func isConnected() -> Bool {
        return true//monitor.currentPath.status == .satisfied
    }

    func setReachabilityChangedHandler(_ handler: @escaping (Bool) -> Void) {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                handler(path.status == .satisfied)
            }
        }
    }
}

