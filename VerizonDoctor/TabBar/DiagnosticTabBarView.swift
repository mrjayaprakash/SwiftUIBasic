//
//  DiagnosticTabBarView.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 25/06/25.
//

import SwiftUI

struct DiagnosticTabBarView: View {
    @State private var selectedTab: DiagnosticTab = .home
    var body: some View {
        TabView(selection: $selectedTab) {
            
            HomeView(
                homeViewModel: HomeViewModel(testService: DiagnosticTestService())
            )
                .tabItem {
                    Label(DiagnosticTab.home.title, systemImage: DiagnosticTab.home.systemImage)
                }
                .tag(DiagnosticTab.home)
            
            DeviceInfoView()
                .tabItem {
                    Label(DiagnosticTab.device.title, systemImage: DiagnosticTab.device.systemImage)
                }
                .tag(DiagnosticTab.device)
            
            TestResultSummaryView(viewModel: TestResultSummaryViewModel(results: []))
                .tabItem {
                    Label(DiagnosticTab.results.title, systemImage: DiagnosticTab.results.systemImage)
                        .tag(DiagnosticTab.results)
                }
            
            ShopView()
                .tabItem {
                    Label(DiagnosticTab.shop.title, systemImage: DiagnosticTab.shop.systemImage)
                }
                .tag(DiagnosticTab.shop)
            
            SupportView()
                .tabItem {
                    Label(DiagnosticTab.support.title, systemImage: DiagnosticTab.support.systemImage)
                }
                .tag(DiagnosticTab.support)
        }
    }
}
