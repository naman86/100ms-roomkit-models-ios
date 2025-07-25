//
//  HMSPeerModel.swift
//  HMSUIKit
//
//  Created by Pawan Dixit on 31/05/2023.
//

import SwiftUI
import Combine
import HMSSDK

public class HMSPeerModel: ObservableObject {
    
    weak var roomModel: HMSRoomModel?
    
    public let id: String
    @Published public var name: String
    @Published public var downlinkQuality: Int? {
        didSet {
            if let quality = downlinkQuality {
                if quality < 0 {
                    displayQuality = 4
                }
                else if quality < 5 {
                    displayQuality = quality
                } else {
                    displayQuality = 4
                }
            }
            else {
                displayQuality = 0
            }
        }
    }
    @Published public var displayQuality: Int = 0
    @Published public internal(set) var isVideoDegraded: Bool
    
    @Published public internal(set) var canScreenShare = false
    @Published public internal(set) var canMute = false
    @Published public internal(set) var canRemoveOthers = false
    @Published public internal(set) var canEndRoom: Bool = false
    @Published public internal(set) var canStartStopHLSStream = false
    @Published public internal(set) var canStartStopRecording = false
    @Published public internal(set) var canUseNoiseCancellation = false
    
    public var customerUserId: String? {
        #if !Preview
        peer.customerUserID
        #else
        return "dummy customer id"
        #endif
    }
    
    @Published public var metadata: HMSStorage<String, Any>
    @Published public var trackModels = [HMSTrackModel]()
    @Published public internal(set) var lastSpokenTimestamp: Date = .distantPast
    @Published public internal(set) var isSpeaking: Bool = false
    
    @Published public internal(set) var isHandRaised: Bool = false
    
    // in-memory data
    @Published public var inMemoryStore = [String: Any?]()
    public var inMemoryStaticStore = [String: Any?]()
    
    @Published public internal(set) var role: HMSRole?
    
    @Published public internal(set) var type: HMSPeerType
    
    @Published public internal(set) var isTemporary: Bool = false
    
#if !Preview
    public let peer: HMSPeer

    init(peer: HMSPeer, roomModel: HMSRoomModel?) {
        self.roomModel = roomModel
        self.peer = peer
        self.id = peer.peerID
        
        self.name = peer.name
        self.type = peer.type
        self.downlinkQuality = peer.networkQuality?.downlinkQuality
        
        self.canScreenShare = false //peer.role?.publishSettings.allowed?.contains("screen") ?? false
        self.canMute = peer.role?.permissions.mute ?? false
        self.canRemoveOthers = peer.role?.permissions.removeOthers ?? false
        let canEndRoom = peer.role?.permissions.endRoom ?? false
        self.canStartStopHLSStream = peer.role?.permissions.hlsStreaming ?? false
        self.canStartStopRecording = false //peer.role?.permissions.browserRecording ?? false
        
        self.canEndRoom = canEndRoom
        self.canUseNoiseCancellation = peer.role?.permissions.noiseCancellation?.enabled ?? false
        
        self.role = peer.role
        
        self.metadata = HMSStorage<String, Any>() { storage in
            
            guard let data = try? JSONSerialization.data(withJSONObject: storage, options: []),
            let dataString = String(data: data, encoding: .utf8) else { return }
            
            Task {
                try await roomModel?.setUserMetadata(dataString)
            }
        }
        
        self.isVideoDegraded = (peer.videoTrack?.isDegraded()) ?? false
        self.isHandRaised = peer.isHandRaised
        
        if peer.isLocal {
            roomModel?.userCanEndRoom = canEndRoom
            updateWhiteboardPermission()
            updateTranscriptionPermission()
            roomModel?.userCanUseNoiseCancellation = canUseNoiseCancellation
        }
        
        updateMetadata()
        
        roomModel?.objectWillChange.send()
    }
    public var isLocal: Bool {
        peer.isLocal
    }
#else
    public let peer: HMSPeer!
    public init(name: String? = nil, isLocal: Bool = false) {
        self.id = UUID().uuidString
        self.name = name ?? "Participant's Name"
        self.canMute = true
        self.role = nil
        self.isLocal = isLocal
        self.metadata = HMSStorage<String, Any>() { _ in}
        self.isVideoDegraded = false
        self.peer = nil
        self.type = .regular
    }
    public var isLocal = false
#endif
}

// Hashable
extension HMSPeerModel: Hashable, Identifiable {
    public static func == (lhs: HMSPeerModel, rhs: HMSPeerModel) -> Bool {
        lhs.id == rhs.id
    }
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
}

#if Preview
public struct PreviewRoleModel {
    public let name: String
    public let permissions = HMSPreviewPermissions()
    public let canPublish = true
    
    public init(name: String) {
        self.name = name
    }
}

public struct HMSPreviewPermissions {
    public let endRoom: Bool = true
    public let removeOthers: Bool = true
    public let unmute: Bool = true
    public let mute: Bool = true
    public let changeRole: Bool = true
    public let hlsStreaming: Bool = true
    public let rtmpStreaming: Bool = true
    public let browserRecording: Bool = true
}
#endif
