//
//  ContentView.swift
//  CardPir
//
//  Created by Jérôme Binachon on 27/07/2023.
//

import SwiftUI
import MultiPeer






struct ContentView: View {
    @StateObject var communicator = Communicator()
    @StateObject var cardModel = CardGameModel()
    
    var body: some View {
        /*ZStack {
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
        .background(
            Image("h13")
                .resizable()
                .scaledToFit()
                .opacity(0.3)
                .padding()
        )*/
        VStack {
            
            HStack {
                Button("Distribute") {
                    cardModel
                        .distributeCards(count: 12)
                        .sortPlayerCards()
                }.padding()
                Spacer()
                Button("Reset") {
                    cardModel.playerCards.removeAll()
                }.padding()
            }
            Spacer()
            PlayerCardsView(model: cardModel)
                .frame(height: 300)
        }
    }
    
    
    

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
