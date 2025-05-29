//
//  HealthEase.swift
//
//  Created by Yang on on 18/2/2025.
//

import SwiftUI
import SwiftData
import SwiftCSV

@main
struct HealthEaseApp: App {
    @State private var scale = 0.8
    @State private var opacity = 0.5
    @State private var rotationAngle: Double = 0 // Rotation state for animation
    @StateObject var trendsVM = TrendsViewModel.shared
    @StateObject var badgesVM = BadgesViewModel.shared
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            StepModel.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @State var initFinish = false
    var body: some Scene {
        WindowGroup {
#warning ("------需要完善-----") //&& trendsVM.loadFinish
            if initFinish  && badgesVM.loadFinish {
                TabBarView()
                    .environmentObject(trendsVM)
            } else {
                ZStack {
                    // 🌟 Matching Background Gradient with Login Screen
                    LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.9), Color.cyan.opacity(0.8)]),
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                        .edgesIgnoringSafeArea(.all)

                    VStack {
                        ZStack {
                            // 🔄 Rotating Circle Animation
                            Circle()
                                .trim(from: 0.2, to: 1.0) // Creates a circular arc instead of full circle
                                .stroke(Color.white.opacity(0.7), lineWidth: 4)
                                .frame(width: 100, height: 100)
                                .rotationEffect(Angle(degrees: rotationAngle)) // Apply rotation effect
                                .onAppear {
                                    withAnimation(Animation.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                                        rotationAngle = 360
                                    }
                                }

                            // 🌟 Enlarging "SwiftApp" Text
                            Text("SwiftApp")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .scaleEffect(scale)
                                .opacity(opacity)
                                .onAppear {
                                    withAnimation(.easeIn(duration: 1)) {
                                        scale = 1.0
                                        opacity = 1.0
                                    }
                                }
                        }

                        // 🚀 "加载中..." Text for clarity
                        Text("Loading...")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.top, 10)
                            .padding()
                        Text("Please wait, data initialization is in progress")
                            .font(Font.system(size: 22, weight: .bold))
                            .foregroundColor(.white.opacity(0.8))
                        
                    }
                }
                
                .task {
                    initData()
                }
            }
                
        }
        .modelContainer(sharedModelContainer)
    }
    
    init() {
        HomeViewModel.shared.container = sharedModelContainer
        TrendsViewModel.shared.container = sharedModelContainer
        BadgesViewModel.shared.container = sharedModelContainer
    }
    
    func initData()  {
        print(NSHomeDirectory())
       
        do {
            
            var descriptor_step = FetchDescriptor<StepModel>()
            descriptor_step.fetchLimit = 1
            let existingStepModels = try sharedModelContainer.mainContext.fetchCount(descriptor_step)
            if existingStepModels == 0 {
                
                let path = Bundle.main.path(forResource: "Step_Count_Per_Minute", ofType: "csv")!
                // From a file (propagating error during file loading)
                let csvFile: CSV = try CSV<Named>(url: URL(fileURLWithPath: path))
                if csvFile.content.rows.count > 0 {
                   let rows = csvFile.content.rows.filter({(Int($0["stepCount"] ?? "0") ?? 0) > 0})
                    
                    let list = rows.map({StepModel(timestamp: $0["timestamp"], id: $0["id"], stepCount: $0["stepCount"],date: $0["timestamp"].toDateWithDateFormat(dateFormat: "yyyy-MM-dd HH:mm:ss"))})
                    list.forEach { stepModel in
                        sharedModelContainer.mainContext.insert(stepModel)
                    }
                }
                
                try sharedModelContainer.mainContext.save()
                
            } else {
               
            }
            initFinish = true
            print("initFinish ")
        } catch {
            print(error.localizedDescription)
        }
        trendsVM.updateData()
        HomeViewModel.shared.updateData()
        BadgesViewModel.shared.updateData()
    }
    
}
