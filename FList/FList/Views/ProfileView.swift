import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewViewModel()
    
    //My functions
    let defaults = UserDefaults.standard
    @State private var alert: Bool = false
    @State private var viewOnlyPB: Bool = false
    @State private var deleteCT: Bool = true
    @State private var defaultSendNotifications: Bool = true
    @State var lockScreen = false
    @State var alertSignOut = false
    @State var deleteOT = false
    
    @State var showEXTasksBtn = false
    
    //For cancel Notifications
    @State var viewNotifyAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                if viewOnlyPB == false {
                    if let user = viewModel.user {
                        profile(user: user)
                    } else {
                        Text("Loading Profile")
                            .padding(.bottom, 20)
                        ProgressView()
                    }
                } else {
                    Spacer()
                    
                    Text("Loading Profile")
                        .padding(.bottom, 20)
                    
                    ProgressView()
                    
                    Spacer()
                    
                    Toggle("Disable Infinity ProgressBar", isOn: $viewOnlyPB)
                        .padding(.bottom, 20)
                        .frame(width: 300)
                        .onChange(of: viewOnlyPB) {
                            if viewOnlyPB == false {
                                defaults.set(false, forKey: "PBAlert")
                                print("AlertToggle Disabled")
                            }
                            
                            if viewOnlyPB == true {
                                defaults.set(true, forKey: "PBAlert")
                                print("AlertToggle is Enabled")
                            }
                        }
                }
            }
            .navigationTitle("Profile")
        }
        .onAppear {
            //Load user data
            viewModel.fetchUser()
            
            //Toggle Variable
            let alertData = UserDefaults.standard.bool(forKey: "bool")
            
            //Set Alert Toggle
            if alertData == true {
                alert = true
                print("AlertData is True")
                print("AlertToggle is True")
            }
            
            if alertData == false {
                alert = false
                print("AlertData is False")
                print("AlertToggle is False")
            }
            
            //Variable deleteCT
            let deleteCTData = UserDefaults.standard.bool(forKey: "deleteCT")
            //Set deleteCT Toggle
            if deleteCTData == true {
                deleteCT = true
                print("DeleteData is True")
                print("DeleteToggle is True")
            }
            
            if deleteCTData == false {
                deleteCT = false
                print("DeleteData is False")
                print("DeleteToggle is False")
            }
            
            //Variable for DefaultSN
            let sendDefaultN = UserDefaults.standard.bool(forKey: "defaultSN")
            
            //Set Alert Toggle
            if sendDefaultN == true {
                defaultSendNotifications = true
                print("DefaultSN is True")
                print("DefaultSNToggle is True")
            }
            
            if sendDefaultN == false {
                defaultSendNotifications = false
                print("DefaultSN is False")
                print("DefaultSNToggle is False")
            }
            
            //Set LockScreen Toggle
            let lockScreenEnabled = UserDefaults.standard.bool(forKey: "lockScreen")
            
            if lockScreenEnabled == true {
                lockScreen = false
            } else {
                lockScreen = true
            }
            
            //Set ViewNotifyAlert Toggle
            let viewNotify = UserDefaults.standard.bool(forKey: "cancelAN")
            if viewNotify == false {
                viewNotifyAlert = true
            }
            if viewNotify == true {
                viewNotifyAlert = false
            }
            
            //Set deleteOT Toggle
            let deleteOutdatedTask = UserDefaults.standard.bool(forKey: "deleteOutdated")
            if deleteOutdatedTask == true {
                deleteOT = true
            }
            if deleteOutdatedTask == false {
                deleteOT = false
            }
            
            //Set showEXTasksBtn Toggle
            let showEXTasksBtnAppData = UserDefaults.standard.bool(forKey: "showEXTasksBtn")
            
            if showEXTasksBtnAppData == true {
                showEXTasksBtn = true
            }
            if showEXTasksBtnAppData == false {
                showEXTasksBtn = false
            }
        }
    }
    
    @ViewBuilder
    func profile(user: User) -> some View {
        //Avatar
        Image(systemName: "person.circle")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.blue)
            .frame(width: 125, height: 125)
            .padding()
        
        //Info: Name, Email, Member since
        VStack(alignment: .leading) {
            HStack {
                Text("Name: ")
                    .bold()
                Text(user.name)
            }
            .padding(.bottom, 5)
            
            HStack {
                Text("Email: ")
                    .bold()
                Text(user.email)
            }
            .padding(.bottom, 5)
            
            HStack {
                Text("Member Since: ")
                    .bold()
                Text("\(Date(timeIntervalSince1970: user.joined).formatted(date: .abbreviated, time: .shortened))")
            }
            .padding(.bottom, 5)
        }
        //Sign Out
        Button("Log Out") {
            alertSignOut.toggle()
        }
        .tint(.red)
        .padding(.top, 10)
        .padding(.bottom, 10)
        .alert("Do you really want to get out ?", isPresented: $alertSignOut) {
            Button("Yes", role: .destructive) {
                viewModel.logOut()
            }
            
            Button("No", role: .cancel) {}
        }
        
        Spacer()
        
        NavigationLink(destination: settings) {
            Text("Settings")
                .font(.system(size: 20))
                .bold()
        }.frame(width: 240).frame(height: 37).background(Color.blue).cornerRadius(10).tint(Color.white)
            .padding(.bottom, 40)
    }
    
    @ViewBuilder
    func settings() -> some View {
        Spacer()
        
        Toggle("Confirm deleting task", isOn: $alert)
            .onChange(of: alert) {
                if alert == false {
                    defaults.set(false, forKey: "bool")
                    print("AlertToggle Disabled")
                }
                
                if alert == true {
                    defaults.set(true, forKey: "bool")
                    print("AlertToggle is Enabled")
                }
            }
            .frame(maxWidth: 300)
            .padding(.bottom, 15)
        
        Toggle("Enable Infinity ProgressBar", isOn: $viewOnlyPB)
            .padding(.bottom, 15)
            .frame(width: 300)
        
        Toggle("Delete completed Tasks when closing app", isOn: $deleteCT)
            .padding(.bottom, 15)
            .frame(width: 300)
            .onChange(of: deleteCT) {
                if deleteCT == false {
                    defaults.set(false, forKey: "deleteCT")
                    print("deleteCTToggle Disabled")
                }
                
                if deleteCT == true {
                    defaults.set(true, forKey: "deleteCT")
                    print("deleteCTToggle is Enabled")
                }
            }
        
        Toggle("Set default Send notifications", isOn: $defaultSendNotifications)
            .padding(.bottom, 15)
            .frame(width: 300)
            .onChange(of: defaultSendNotifications) {
                if defaultSendNotifications == false {
                    defaults.set(false, forKey: "defaultSN") //Change
                    print("DefaultSN Toggle Disabled")
                }
                
                if defaultSendNotifications == true {
                    defaults.set(true, forKey: "defaultSN")
                    print("DefaultSN Toggle is Enabled")
                }
            }
        
        Toggle("App Lock Screen", isOn: $lockScreen)
            .onChange(of: lockScreen) {
                let defaults = UserDefaults.standard
                
                if lockScreen == false {
                    defaults.set(true, forKey: "lockScreen")
                    print("lockScreen Toggle Disabled")
                }
                
                if lockScreen == true {
                    defaults.set(false, forKey: "lockScreen")
                    print("lockScreen Toggle is Enabled")
                }
            }
            .frame(width: 300)
            .padding(.bottom, 15)
        
        Toggle("Disable Notifications", isOn: $viewNotifyAlert)
            .onChange(of: viewNotifyAlert) {
                let defaults = UserDefaults.standard
                
                if viewNotifyAlert == true {
                    defaults.set(false, forKey: "cancelAN")
                    print("cancelAN Toggle Disabled")
                }
                
                if viewNotifyAlert == false {
                    defaults.set(true, forKey: "cancelAN")
                    print("cancelAN Toggle is Enabled")
                }
            }
            .frame(width: 300)
            .padding(.bottom, 15)
        
        Toggle("Delete outdated tasks", isOn: $deleteOT)
            .onChange(of: deleteOT) {
                let defaults = UserDefaults.standard
                
                if deleteOT == false {
                    defaults.set(false, forKey: "deleteOutdated")
                    print("deleteOT Toggle Disabled")
                }
                
                if deleteOT == true {
                    defaults.set(true, forKey: "deleteOutdated")
                    print("deleteOT Toggle is Enabled")
                }
            }
            .frame(width: 300)
            .padding(.bottom, 15)
        
        Toggle("Show 'Create Example Tasks' Button", isOn: $showEXTasksBtn)
            .onChange(of: showEXTasksBtn) {
                let defaults = UserDefaults.standard
                
                if showEXTasksBtn == false {
                    defaults.set(false, forKey: "showEXTasksBtn")
                    print("showEXTasksBtn Toggle Disabled")
                }
                
                if showEXTasksBtn == true {
                    defaults.set(true, forKey: "showEXTasksBtn")
                    print("showEXTasksBtn Toggle is Enabled")
                }
            }
            .frame(width: 300)
            .padding(.bottom, 50)
        
        NavigationLink(destination: TestNotificaitonsView()) {
            Text("Test Notifications")
                .frame(width: 240).frame(height: 37).background(Color.blue).cornerRadius(10).tint(Color.white)
        }
        .padding(.bottom, 50)
        
    }
}

#Preview {
    ProfileView()
}
