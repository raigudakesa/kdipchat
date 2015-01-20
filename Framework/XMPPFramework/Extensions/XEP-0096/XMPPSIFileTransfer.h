//
//  MultiCast.h
//  TrustTextXMPP
//
//  Created by Min Kwon on 3/11/13.
//  Copyright (c) 2013 Min Kwon. All rights reserved.
//
//  Implementation of http://xmpp.org/extensions/xep-0096.html


#import <Foundation/Foundation.h>
#import "XMPP.h"
#import "TURNSocket.h"
#import "GCDAsyncSocket.h"

typedef enum {
    kXMPPSIFileTransferStateNone,
    kXMPPSIFileTransferStateSending,
    kXMPPSIFileTransferStateReceiving
} XMPPSIFileTransferState;

typedef enum {
    kXMPPSIFileTransferMimeTypeNone,
    kXMPPSIFileTransferMimeTypeJPG,
    kXMPPSIFileTransferMimeTypePNG,
    kXMPPSIFileTransferMimeTypeGIF
} XMPPSIFileTransferMimeType;

@interface XMPPSIFileTransfer : XMPPModule<TURNSocketDelegate, GCDAsyncSocketDelegate> {
    TURNSocket *turnSocket;
    XMPPSIFileTransferState state;
    NSMutableData *receivedData;
    XMPPSIFileTransferMimeType mimeType;
    XMPPJID *senderJID;
    int step;
}

- (void)initiateFileTransferTo:(XMPPJID*)to withData:(NSData*)data;

/**
 * We need to keep track of the sid (the id of the <s> element. When a negotation is received,
 * we will either receive a set iq or send a set iq with a particular sid.  This sid is used
 * again when the file is sent or received, and must match. 
**/
@property (nonatomic, strong) NSString *sid;

@end



@protocol XMPPSIFileTransferDelegate <NSObject>
@required
- (void)receivedImage:(NSData*)image from:(XMPPJID*)from;
@end
