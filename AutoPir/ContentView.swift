//
//  ContentView.swift
//  AutoPir
//
//  Created by Jérôme Binachon on 27/07/2023.
//

import SwiftUI
import MultiPeer






struct ContentView: View {
    @StateObject var communicator = Communicator()
    
    var body: some View {
        VStack {
            ScrollViewReader { scrollView in
                
                Text("messages")
                    .padding()
                    .font(.headline)
                
                ScrollView {
                    ForEach(communicator.messages, id:\.self) { message in
                        Text("\(message.date) \(message.text)")
                    }
                    Text("x")
                        .id("last")
                }
                .onChange(of: communicator.messages) { _ in
                    withAnimation {
                        scrollView.scrollTo("last")
                    }
                }
            }
            
            Text("Devices")
                .padding()
                .font(.headline)
                ScrollView {
                    ForEach(communicator.devices, id:\.self) { deviceName in
                        Text(deviceName)
                    }
            }
            
            HStack {
                Button("Reset") {
                    communicator.messages.removeAll()
                    communicator.reset()
                }
                Spacer()
                Button("Send Data") {
                    communicator.sendString("Hello World")
                }

            }
        }
        .padding()
    }
    
    
    

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
