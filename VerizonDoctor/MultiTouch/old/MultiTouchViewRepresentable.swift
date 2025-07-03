//
//  MultiTouchViewRepresentable.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 02/07/25.
//

import SwiftUI


// MARK: - MultiTouchViewRepresentable

struct MultiTouchViewRepresentable: UIViewRepresentable {
    var onTouches: (([CGPoint]) -> Void)

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        // Essential: Allow the underlying UIView to process multiple touches.
        view.isMultipleTouchEnabled = true

        let gesture = MultiTouchGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleGesture(_:)))
        gesture.onTouchesChanged = { points in
            context.coordinator.parent.onTouches(points)
        }
        view.addGestureRecognizer(gesture)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // No updates needed for the UIView itself
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: MultiTouchViewRepresentable

        init(_ parent: MultiTouchViewRepresentable) {
            self.parent = parent
        }

        @objc func handleGesture(_ gesture: MultiTouchGestureRecognizer) {
            // The actual touch points are already being sent via the onTouchesChanged closure
            // We just need this method to satisfy the UIGestureRecognizer target/action pattern.
            // No direct processing here; it's handled by `onTouchesChanged`.
        }
    }
}
