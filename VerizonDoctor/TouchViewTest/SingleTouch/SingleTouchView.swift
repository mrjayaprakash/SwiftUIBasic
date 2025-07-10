//
//  SingleTouchView.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 03/07/25.
//

import SwiftUI
import UIKit

/// A transparent view that captures single-touch input and passes the location back.
struct SingleTouchView: UIViewRepresentable {
    var onTouch: (CGPoint) -> Void

    func makeUIView(context: Context) -> UIView {
        let view = SingleTouchCaptureView()
        view.onTouch = onTouch
        view.isMultipleTouchEnabled = false // ✅ Restrict to ONE touch
        view.backgroundColor = .clear
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    class SingleTouchCaptureView: UIView {
        var onTouch: (CGPoint) -> Void = { _ in }

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else { return }
            onTouch(touch.location(in: self))
        }

        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else { return }
            onTouch(touch.location(in: self))
        }

        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {}
        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {}
    }
}
struct TouchCaptureView: UIViewRepresentable {
    let onTouch: (CGPoint) -> Void

    func makeUIView(context: Context) -> UIView {
        let view = TouchTrackingUIView()
        view.onTouch = onTouch
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    class TouchTrackingUIView: UIView {
        var onTouch: ((CGPoint) -> Void)?

        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                let location = touch.location(in: self)
                onTouch?(location)
            }
        }

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            touchesMoved(touches, with: event)
        }
    }
}
