//
//  MultiTouchGestureRecognizer.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 02/07/25.
//

//import UIKit
import SwiftUI

// MARK: - MultiTouchGestureRecognizer

class MultiTouchGestureRecognizer: UIGestureRecognizer {
    // A closure that will be called whenever touches change.
    // It passes an array of CGPoints, representing the current locations of all active touches.
    var onTouchesChanged: (([CGPoint]) -> Void)?

    // Dictionary to keep track of active touches and their current locations.
    private var activeTouches: [UITouch: CGPoint] = [:]

    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        // Crucially, enable multiple touch detection for this gesture recognizer.
        self.cancelsTouchesInView = false // Allows other gestures to also receive touches
        self.delaysTouchesEnded = false   // Reports touch end quickly
        self.delaysTouchesBegan = false   // Reports touch begin quickly
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        for touch in touches {
            activeTouches[touch] = touch.location(in: view)
        }
        state = .began // Inform the gesture recognizer that a touch began
        sendTouches()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        for touch in touches {
            activeTouches[touch] = touch.location(in: view)
        }
        state = .changed // Inform the gesture recognizer that touches moved
        sendTouches()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        for touch in touches {
            activeTouches.removeValue(forKey: touch)
        }
        state = .ended // Inform the gesture recognizer that touches ended
        sendTouches()
        // If no more active touches, reset the gesture recognizer state.
        if activeTouches.isEmpty {
            state = .possible
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        for touch in touches {
            activeTouches.removeValue(forKey: touch)
        }
        state = .cancelled // Inform the gesture recognizer that touches were cancelled
        sendTouches()
        // If no more active touches, reset the gesture recognizer state.
        if activeTouches.isEmpty {
            state = .possible
        }
    }

    // Called when the gesture recognizer is reset (e.g., when touches end or are cancelled).
    override func reset() {
        activeTouches.removeAll()
        onTouchesChanged?([]) // Clear all touch points
    }

    // Helper method to send the current touch locations.
    private func sendTouches() {
        // Ensure updates are dispatched on the main thread, as UI updates must be.
        DispatchQueue.main.async {
            self.onTouchesChanged?(Array(self.activeTouches.values))
        }
    }
}
