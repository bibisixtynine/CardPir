//
//  Communicator.swift
//  CardPir
//
//  Created by Jérôme Binachon on 27/07/2023.
//

import SwiftUI

import MultiPeer

class Communicator: ObservableObject, MultiPeerDelegate {
    enum DataType: UInt32 {
      case string = 1
      case image = 2
      // ...
    }
    
    @Published var messages = [Message]()
    @Published var devices = [String]()
    
    
    init() {
        MultiPeer.instance.delegate = self
        MultiPeer.instance.initialize(serviceType: "cardpir-app")
        MultiPeer.instance.autoConnect()
    }
    
    func sendString(_ message: String) {
        MultiPeer.instance.send(object: message, type: DataType.string.rawValue)
    }
    
    func reset() {
        MultiPeer.instance.send(object: "reset", type: DataType.string.rawValue)
    }
    
    func multiPeer(didReceiveData data: Data, ofType type: UInt32, from peerID: MCPeerID) {
      switch type {
        case DataType.string.rawValue:
          let string = data.convert() as! String
          // do something with the received string
          messages.append(Message(text: string))
          if string == "reset" {
              messages.removeAll()
          }
          break
                  
        case DataType.image.rawValue:
          //let image = UIImage(data: data)
          // do something with the received UIImage
          break
                  
        default:
          break
      }
    }

    func multiPeer(connectedDevicesChanged devices: [String]) {
        self.devices = devices
    }
}
