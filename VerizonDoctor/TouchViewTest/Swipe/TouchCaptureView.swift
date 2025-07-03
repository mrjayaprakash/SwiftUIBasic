//
//  TouchCaptureView.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 02/07/25.
//

/*import SwiftUI

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

import SwiftUI

struct MultiTouchCaptureView: UIViewRepresentable {
    var onTouch: (CGPoint) -> Void

    func makeUIView(context: Context) -> TouchView {
        let view = TouchView()
        view.onTouch = onTouch
        return view
    }

    func updateUIView(_ uiView: TouchView, context: Context) {}

    class TouchView: UIView {
        var onTouch: ((CGPoint) -> Void)?
        private var activeTouches: [UITouch: CGPoint] = [:]

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                let location = touch.location(in: self)
                activeTouches[touch] = location
                DispatchQueue.main.async {
                    self.onTouch?(location)
                }
            }
        }

        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                let location = touch.location(in: self)
                activeTouches[touch] = location
                DispatchQueue.main.async {
                    self.onTouch?(location)
                }
            }
        }

        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                activeTouches.removeValue(forKey: touch)
            }
        }

        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                activeTouches.removeValue(forKey: touch)
            }
        }
    }
}*/
