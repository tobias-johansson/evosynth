//
// Programmer:  Craig Stuart Sapp
// Date:    Mon Jun  8 14:54:42 PDT 2009
// Filename:    testout.c
// Syntax:  C; Apple OSX CoreMIDI
// $Smake:  gcc -o %b %f -framework CoreMIDI -framework CoreServices
//              note: CoreServices needed for GetMacOSSStatusErrorString().
//
// Description: This program plays a single MIDI note (middle C) on all
//              MIDI output ports which the program can find.
//
// Derived from "Audio and MIDI on Mac OS X" Preliminary Documentation,
// May 2001 Apple Computer, Inc. found in PDF form on the developer.apple.com
// website, as well as using links at the bottom of the file.
//

#include <CoreMIDI/CoreMIDI.h>    /* interface to MIDI in Macintosh OS X */
#include <unistd.h>               /* for sleep() function                */
//#include <stdlib.h>
#include <time.h>
#include "commands.h"
#define MESSAGESIZE 3             /* byte count for MIDI note messages   */

void playPacketListOnAllDevices   (MIDIPortRef     midiout,
                                   const MIDIPacketList* pktlist);

/////////////////////////////////////////////////////////////////////////

#define MIDI(a, b, c, d) 0x80*a + 0x40*b + 0x20*c + 0x10*d

#define MIDI_NOTE_ON      MIDI(1,0,0,1)
#define MIDI_NOTE_OFF     MIDI(1,0,0,0)
#define MIDI_CC           MIDI(1,0,1,1)
#define MIDI_CC_NRPN_PARAM_LSB  0x62
#define MIDI_CC_NRPN_PARAM_MSB  0x63
#define MIDI_CC_NRPN_VALUE_LSB  0x06
#define MIDI_CC_NRPN_VALUE_MSB  0x26

Byte cc_commands[COMMANDS_LIST_SIZE] = { COMMANDS_LIST };
NSString* cc_command_name[] = { COMMAND_NAMES };


void play(MIDIPortRef midiout) {
    MIDITimeStamp timestamp = 0;
    Byte buffer[1024];
    MIDIPacketList *packetlist = (MIDIPacketList*)buffer;
    MIDIPacket *currentpacket = MIDIPacketListInit(packetlist);
    
    NSLog(@"%3s %3s %3s %3s", "i", "CC", "cmd", "val");
    for (int i = 0; i < 41; ++i) {

        
        Byte cmd = cc_commands[i];
        Byte rnd = rand() % 128;
        NSString* name = cc_command_name[i];
        
        if (cmd == VCA_Level || cmd == Osc_1_Freq_Fine) continue;
        if (cmd == Filter_Attack || cmd == Amp_Attack || cmd == Env_3_Attack || cmd == Amp_Delay) {
            rnd = rnd % 10;
        }
        
        NSLog(@"%3d %3d %3d %3d %@", i, MIDI_CC, cmd, rnd, name);
        Byte set[] = {MIDI_CC, cmd, rnd};
        currentpacket = MIDIPacketListAdd(packetlist, sizeof(buffer),
                                          currentpacket, timestamp, sizeof(set), set);
    }
    
//    Byte noteon[] = {0x90, 60, 90};
//    currentpacket = MIDIPacketListAdd(packetlist, sizeof(buffer),
//                                      currentpacket, timestamp, sizeof(noteon), noteon);
    
    playPacketListOnAllDevices(midiout, packetlist);
}

void off(MIDIPortRef midiout) {
    MIDITimeStamp timestamp = 0;
    Byte buffer[1024];
    MIDIPacketList *packetlist = (MIDIPacketList*)buffer;
    MIDIPacket *currentpacket = MIDIPacketListInit(packetlist);
    Byte noteon[] = {0x80, 60, 90};
    currentpacket = MIDIPacketListAdd(packetlist, sizeof(buffer),
                                      currentpacket, timestamp, sizeof(noteon), noteon);
    
    playPacketListOnAllDevices(midiout, packetlist);
}

int main(void) {
    
    srand(time(NULL));
    
    // Prepare MIDI Interface Client/Port for writing MIDI data:
    MIDIClientRef midiclient  = (MIDIClientRef)NULL;
    MIDIPortRef   midiout     = (MIDIPortRef)NULL;
    OSStatus status;
    if ((status = MIDIClientCreate(CFSTR("TeStInG"), NULL, NULL, &midiclient))) {
        printf("Error trying to create MIDI Client structure: %d\n", status);
        exit(status);
    }
    if ((status = MIDIOutputPortCreate(midiclient, CFSTR("OuTpUt"), &midiout))) {
        printf("Error trying to create MIDI output port: %d\n", status);
        exit(status);
    }
    
    play(midiout);
    
    sleep(3);
    
    off(midiout);
    
    //jag älskar hästar!
    
    if ((status = MIDIPortDispose(midiout))) {
        printf("Error trying to close MIDI output port: %d\n", status);
        exit(status);
    }
    midiout = (MIDIPortRef)NULL;
    
    if ((status = MIDIClientDispose(midiclient))) {
        printf("Error trying to close MIDI client: %d\n", status);
        exit(status);
    }
    midiclient = (MIDIClientRef)NULL;
    
    return 0;
}


/////////////////////////////////////////////////////////////////////////

//////////////////////////////
//
// playPacketOnAllDevices -- play the list of MIDI packets
//    on all MIDI output devices which the computer knows about.
//    (Send the MIDI message(s) to all MIDI out ports).
//

void playPacketListOnAllDevices(MIDIPortRef midiout,
                                const MIDIPacketList* pktlist) {
    // send MIDI message to all MIDI output devices connected to computer:
    ItemCount nDests = MIDIGetNumberOfDestinations();
    ItemCount iDest;
    OSStatus status;
    MIDIEndpointRef dest;
    for(iDest=0; iDest<nDests; iDest++) {
        dest = MIDIGetDestination(iDest);
        if ((status = MIDISend(midiout, dest, pktlist))) {
            printf("Problem sendint MIDI data on port %ld\n", iDest);
            exit(status);
        }
    }
}


/////////////////////////////////////////////////////////////////////////
//
// NOTES
//
/*
 
 Crapple functions used in this program:
 
 /// TYPEDEFS //////////////////////////////////////////////////////////////
 
 UInt16    => unsigned short int
 UInt32    => unsigned long int
 UInt64    => unsigned long long int
 Byte      => char
 ByteCount => int
 OSStatus  => int
 Boolean   => char
 
 MIDITimeStamp => UInt64
 A host clock time representing the time of an event, as returned by
 mach_absolute_time() or UpTime().  Since MIDI applications will tend to
 do a fair amount of math with the times of events, it is more
 convenient to use a UInt64 than an AbsoluteTime.  See CoreAudio/HostTime.h
 
 struct MIDIPacket { MIDITimeStamp timeStamp; UInt16 length; Byte data[256]; };
 timeStamp = The time at which the events occurred (if receiving MIDI),
 or the time at which the events are to be played (if sending
 MIDI).  Zero means "now" when sending MIDI data.  The time
 stamp applies to the first MIDI byte in the packet.
 length    = The number of valid MIDI bytes which follow in data[].
 It may be larger than 256 bytes if the packet is dynamically
 allocated.
 data      = A variable-length stream of MIDI messages. Running status
 is not allowed.  In the case of system-exclusive messages,
 a packet may only contain a single message, or portion
 of one, with no other MIDI events.  The MIDI messages in
 the packet must always be complete, except for
 system-exclusive messages.  data[] is declared to be 256
 bytes in length so clients don't have to create custom data
 structures in simple situations.
 
 struct MIDIPacketList { UInt32  numPackets; MIDIPacket packet[1]; };
 numPackets = The number of MIDIPackets in the list.
 packet     = An open-ended array of variable-length MIDIPackets.
 The timestamps in the packet list must be in ascending order.
 Note that the packets in the list, while defined as an array, may
 *not* be accessed as an array, since they are vairable-length.  To
 iterate through the packets in a packet list, use a loop such as:
 MIDIPacket *packet = &packetList->packet[0];
 for (int i=0; i<packetList->numPackets; i++) {
 ...
 packet = MIDIPacketNext(packet);
 }
 
 struct MIDISysexSendRequest {
 MIDIEndpointRef destination;
 const Byte     *data;
 UInt32          bytesToSend;
 Boolean         complete;
 Byte            reserved[3];  // to fill up 4-byte boundary, I suppose.
 MIDICompetionProc completionProc;
 void *completionRefCon;
 };
 destination      = The endpoint to which the event is to be sent.
 data             = Initially, a pointer to the sys-ex event to be
 sent.  MIDISendSysex will advance this pointer
 as bytes are sent.
 bytesToSend      = Initially, the number of bytes to be sent.
 MIDISendSysex will decrement this counter
 as bytes are sent.
 complete         = The client may set this to true at any time
 to abort transmission.  The implementation
 sets this to true when all bytes have been sent.
 completionProc   = Called when all bytes ahve been sent, or after the
 client has set complete to true.
 completionRefCon = Passed as a refCon to completionProc.
 This data structure represents a request to send a single system-exclusive
 MIDI event to a MIDI destination asynchronously.
 
 
 /// MIDI OPENING/CLOSING FUNCTIONS ////////////////////////////////////////
 
 OSStatus MIDIClientCreate(CFStringRef name, MIDINotifyProc notifyProc,
 void* notifyRefCon, MIDIClientRef* outClient);
 name         = The client's name.
 notifyProc   = An optional (may be NULL) callback function through
 which the client will receive notifications of changes
 to the system.
 notifyRefCon = An optional (may be NULL) refCon passed back to
 notifyRefCon.
 outClient    = On successful return, points to the newly-created
 MIDIClientRef.
 All clients must be created and disposed on the same thread.
 Note that notifyProc will always be called on the run loop
 which was current when MIDIClientCreate was first called.
 
 
 OSStatus MIDIOutputPortCreate(MidiClientRef midiclient, CFStringRef portName,
 MIDIPortRef *outPort);
 client   = The client to own the newly-created port.
 portName = The name of the port.
 outPort  = On successful return, points to the newly-created MIDIPort.
 Creates an output port through which the client may send outgoing
 MIDI messages to any MIDI destination.  Output ports provied a
 mechanism for MIDI merging.  CoreMIDI assumes that each output port
 will be responsible for sending only a single MIDI stream to each
 destination, although a single port may address all of the destinations
 in the system.  Multiple output ports are only necessary when an
 application is capable of directing multiple simultaneous MIDI streams
 to the same destination.
 
 
 OSStatus MIDIPortDispose(MIDIPortRef port);
 port = The port to dispose.
 It is not usually necessary to call this function.  When an application's
 MIDIClient's are automatically disposed at termination, or explicitly,
 via MIDIClientDispose, the client's ports are automatically disposed at
 that time.
 
 OSS MIDIClientDispose(MIDIClientRef client);
 client = The client to dispose
 Not an essential function to call; CoreMIDI framework will
 automatically dispose all MIDIClients when an application terminates.
 
 
 /// MIDI PACKET FUNCTIONS /////////////////////////////////////////////////
 
 MIDIPacket* MIDIPacketListInit(MIDIPacketList* packetList);
 packetList = The packet list to be initialized.
 Returns a pointer to the first MIDIPacket in the packet list.
 
 MIDIPacket* MIDIPacketListAdd(MIDIPacketList* packetList, ByteCount listSize,
 MIDIPacket* curPacket, MIDITimeStamp time,
 ByteCount nData, const Byte* data);
 packetList = The packet list to which the event is to be added.
 listSize   = The size, in bytes, of the packet list.
 curPacket  = A packet pointer returned by a previous call to
 MIDIPacketListInit() or MIDIPacketListAdd() for this
 packet list.
 time       = The new event's time (when to play the MIDI event
 when this is output data).
 nData      = The length of the new event, in bytes.
 data       = The new event.  May be a single MIDI event, or a
 partial sys-ex event.  Running status is *not*
 permitted.
 Returns null if there was not room in the packet for the event; otherwise,
 returns a packet point which should be passed as CurPacket in a
 subsequent call to this function.  The maximum size of a packet list is
 65536 bytes.  Large sysex messages must be sent in smaller packet
 lists.
 
 
 
 /// MIDI SEND FUNCTIONS ///////////////////////////////////////////////////
 
 OSStatus MIDISend(MIDIPortRef port, MIDIEndpointRef dest,
 const MIDIPacketList *packetList);
 port       = The output port through which the MIDI is to be sent.
 dest       = The destination to receive the events.
 packetList = The MIDI events to be sent.
 Events with future timestamps are scheduled for future delivery.
 CoreMIDI performs and needed MIDI merging.
 
 
 
 /// OTHER USEFUL FUNCTIONS ////////////////////////////////////////////////
 
 OSStatus MIDIRestart(void);
 This function forces CoreMIDI to ask its drivers to rescan for hardware.
 (OSX10.1 and later).
 
 OSStatus MIDISendSysex(MIDISysexSendRequest* request);
 request = contains the destination, and a pointer to the MIDI data
 to be sent.
 request->data must point to a single complete or partial MIDI
 system-exclusive message.
 
 
 /// LINKS AND MISC. NOTES /////////////////////////////////////////////////
 
 MIDIServices.h Documentation:
 http://developer.apple.com/DOCUMENTATION/MusicAudio/Reference/CACoreMIDIRef/MIDIServices/CompositePage.html
 
 CoreMIDI Documentation:
 https://developer.apple.com/documentation/MusicAudio/Reference/CACoreMIDIRef/MIDIServices/index.html
 
 OSStatus Information:
 https://developer.apple.com/documentation/Carbon/Reference/ErrorHandler/Reference/reference.html#//apple_ref/doc/uid/TP40000867-CH201-DontLinkElementID_2
 
 // Example MIDI I/O program: http://bl0rg.net/~manuel/midi-merge.c
 // MIDIOutputPortCreate: http://xmidi.com/docs/coremidi34.html
 // MIDI echo example: http://www.allegro.cc/forums/thread/598206
 // MidiPacket *MIDIPacketNext(MidiPacket *pkt);
 // MidiPacket *MIDIPacketListInit(MidiPacketList *pktlist);
 // MIDIPacket *MIDIPacketListAdd(MIDIPacketList *pktlist, ByteCount
 //    listSize, MidiPacket *curPacket, MIDITimeStamp time, ByteCount nData,
 //    Byte *data);
 // MIDISend(MIDIPortRef port, MIDIEndpointRef dest, const MIDIPacketList*pktlist);
 // OSStatus string: http://lists.apple.com/archives/QuickTime-API/2006/Oct/msg00092.html
 
 
 */

