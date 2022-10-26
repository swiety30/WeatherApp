//
//  AsyncTimer.swift
//  WeatherApp
//
//  Created by Paweł Świątek on 26/10/2022.
//

import Foundation

class AsyncTimer {
    private var tasks: [String: Task<(), Never>] = [:]

    func start(for key: String, every: Double) -> AsyncStream<Void> {
        let stream = AsyncStream<Void> { continuation in
            let timerSequence = Timer
                .publish(every: every,
                         tolerance: 1,
                         on: .main,
                         in: .common)
                .autoconnect()
                .values

            let timerTask = Task {
                for await _ in timerSequence {
                    if !Task.isCancelled {
                        continuation.yield()
                    } else {
                        continuation.finish()
                    }
                }
            }
            tasks[key] = timerTask
        }
        return stream
    }

    func cancelTimmer(for key: String) {
        tasks[key]?.cancel()
        tasks.removeValue(forKey: key)
    }
}
