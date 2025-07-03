//
//  MultiTouchGestureView.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 02/07/25.
//

import SwiftUI


class TouchCaptureUIView: UIView {
    var onTouchesChanged: ([CGPoint]) -> Void = { _ in }
    private var activeTouches: [UITouch: CGPoint] = [:]

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            activeTouches[touch] = touch.location(in: self)
        }
        reportTouches()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            activeTouches[touch] = touch.location(in: self)
        }
        reportTouches()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            activeTouches.removeValue(forKey: touch)
        }
        reportTouches()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            activeTouches.removeValue(forKey: touch)
        }
        reportTouches()
    }

    private func reportTouches() {
        DispatchQueue.main.async {
            self.onTouchesChanged(Array(self.activeTouches.values))
        }
    }
}

struct MultiTouchGestureView: UIViewRepresentable {
    var onTouchesChanged: ([CGPoint]) -> Void

    func makeUIView(context: Context) -> TouchCaptureUIView {
        let view = TouchCaptureUIView()
        view.onTouchesChanged = onTouchesChanged
        view.isMultipleTouchEnabled = true
        return view
    }

    func updateUIView(_ uiView: TouchCaptureUIView, context: Context) {}
}
