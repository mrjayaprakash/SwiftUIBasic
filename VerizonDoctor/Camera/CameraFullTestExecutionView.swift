//
//  CameraFullTestExecutionView.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 15/07/25.
//


import SwiftUI
import AVFoundation

struct CameraFullTestExecutionView: View {
    @ObservedObject var viewModel: CameraTestViewModel
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            CameraPreview(session: viewModel.session)
                .ignoresSafeArea()
            
            VStack {
                // Camera metrics
                HStack(spacing: 12) {
                    Label("ISO: \(Int(viewModel.iso))", systemImage: "speedometer")
                    Label("f/\(String(format: "%.1f", viewModel.aperture))", systemImage: "camera.aperture")
                    Label("EV: \(String(format: "%.2f", viewModel.exposureValue))", systemImage: "light.min")
                }
                .padding()
                .background(Color.black.opacity(0.5))
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                Spacer()
                
                // Capture and exit buttons
                HStack(spacing: 40) {
                    Button {
                        viewModel.capturePhoto()
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 44))
                            .foregroundColor(.green)
                    }
                    
                    Button {
                        viewModel.markResult(passed: false)
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 44))
                            .foregroundColor(.red)
                    }
                }
                .padding(.bottom, 40)
            }
            .padding()

            // Image review overlay
            if let image = viewModel.capturedImage {
                Color.black.opacity(0.8).ignoresSafeArea()
                
                VStack(spacing: 16) {
                    Text("Review Photo")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    HStack(spacing: 20) {
                        Button("✅ Pass") {
                            viewModel.markResult(passed: true)
                            isPresented = false
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button("❌ Fail") {
                            viewModel.markResult(passed: false)
                            isPresented = false
                        }
                        .buttonStyle(.bordered)
                        
                        Button("🔄 Retake") {
                            viewModel.capturedImage = nil
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(16)
                .shadow(radius: 8)
                .padding()
            }
        }
        .onAppear {
            viewModel.startTest()
        }
        .onReceive(Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()) { _ in
            viewModel.updateCameraStats()
        }
        .onChange(of: viewModel.testCompleted) { completed in
            if completed {
                isPresented = false
            }
        }
    }
}
