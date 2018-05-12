#Create a simulator object
set ns [new simulator]

#Define colours for dataflows
$ns color 1 Green
$ns color 2 Blue

#Create the tracefiles
set tf [open out.tr w]
$ns trace-all $tf

#Open the nam trace file
set nf [open out.nam w]
$ns namtrace-all $nf

#Define a 'finish' procedure
proc finish{} {
	global ns tf nf
	$ns flush-trace

	#Close the trace file
	close $nf
	close $tf

	#Execute nam on the trace file
	exec nam out.nam &
	exit 0
}

#Create 4 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set r1 [$ns node]
set r2 [$ns node]

#Create links between the nodes
$ns duplex-link $n0 $r1 10Mb 10ms DropTail
$ns duplex-link $n1 $r1 10Mb 10ms DropTail
$ns duplex-link $r1 $r2 5Mb 20ms DropTail
$ns duplex-link $r2 $n2 10Mb 10ms DropTail
$ns duplex-link $r2 $n3 10Mb 10ms DropTail

#Node position for NAM
$ns duplex-link-op $n0 $r1 orient right-down
$ns duplex-link-op $n1 $r1 orient right-up
$ns duplex-link-op $r1 $r2 orient right
$ns duplex-link-op $r2 $n2 orient right-up
$ns duplex-link-op $r2 $n3 orient right-down

#Set a label to the bottleneck link
$ns duplex-link-op $r1 $r2 label "Bottleneck-Link"

#Monitor the queue of the bottleneck link
$ns duplex-link-op $r1 $r2 queuePos 0.5

#Setup a TCP Connection
set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp
set sinktcp [new Agent/TCPSink]
$ns attach-agent $n2 $sinktcp
$ns connect $tcp $sinktcp
$tcp set fid_ 1

#Setup a FTP over TCP connection
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP

#Setup a UDP Connection
set udp [new Agent/UDP]
$ns attach-agent $n1 $udp
set sinkudp [new Agent/UDPSink]
$ns attach-agent $n4 $sinkudp
$ns connect $udp $sinkudp
$udp set fid_ 2

#Setup a CBR over UDP connection
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set type_ CBR
$cbr set packet_size_ 1000
$cbr set rate_ 1mb
$cbr set random_ false

#Schedule Events
$ns at 0.1 "cbr start"
$ns at 1.0 "ftp start"
$ns at 4.0 "ftp stop"
$ns at 4.5 "cbr stop"

#Call finish procedure
$ns at 5.0 "finish"

#Run the simulation
$ns run







