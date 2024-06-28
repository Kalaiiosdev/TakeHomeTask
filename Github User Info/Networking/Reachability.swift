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
        monitor.pathUpdateHandler = { path in
            print("Path update handler called with status: \(path.status == .satisfied ? "Connected" : "Disconnected")")
        }
    }

    func isConnected() -> Bool {
        print("Checking current path status: \(monitor.currentPath.status == .satisfied ? "Connected" : "Disconnected")")
        return monitor.currentPath.status == .satisfied
    }

    func setReachabilityChangedHandler(_ handler: @escaping (Bool) -> Void) {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                print("Path update handler on main thread with status: \(path.status == .satisfied ? "Connected" : "Disconnected")")
                handler(path.status == .satisfied)
            }
        }
    }
}
