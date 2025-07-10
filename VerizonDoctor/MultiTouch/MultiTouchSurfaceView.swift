//
//  Untitled.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 04/07/25.
//

import SwiftUI

class TouchSurfaceView: UIView {
    var onTouchesChanged: ([CGPoint]) -> Void = { _ in }
    private var active: [UITouch: CGPoint] = [:]

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { active[$0] = $0.location(in: self) }
        report()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { active[$0] = $0.location(in: self) }
        report()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { active.removeValue(forKey: $0) }
        report()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { active.removeValue(forKey: $0) }
        report()
    }

//    private func report() {
//        DispatchQueue.main.async {
//            self.onTouchesChanged(Array(self.active.values))
//        }
//    }
    private func report() {
        DispatchQueue.main.async {
            let convertedPoints = self.active.values.map { touchPoint in
                self.convert(touchPoint, to: nil) // Convert to screen coordinates
            }
            self.onTouchesChanged(convertedPoints)
        }
    }
}

struct MultiTouchSurfaceView: UIViewRepresentable {
    var onTouchesChanged: ([CGPoint]) -> Void

    func makeUIView(context: Context) -> TouchSurfaceView {
        let view = TouchSurfaceView()
        view.onTouchesChanged = onTouchesChanged
        view.isMultipleTouchEnabled = true
        return view
    }

    func updateUIView(_ uiView: TouchSurfaceView, context: Context) {}
}
