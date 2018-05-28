#Create a simulator object
set ns [new Simulator]

#Define colours for dataflows
$ns color 1 Blue
$ns color 2 Red

#Trace file
set tf [open out1.tr w]
$ns trace-all $tf

#Open the nam trace file
set nf [open out1.nam w]
$ns namtrace-all $nf

#Define a 'finish' procedure
proc finish {} {
	global ns nf tf
	$ns flush-trace

	#Close the trace file
	close $nf
	close $tf

	#Execute nam on the trace file
	exec nam out1.nam &
	exit 0
}

#Create 6 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set r1 [$ns node]
set r2 [$ns node]

#Create links between the nodes
$ns duplex-link $n0 $r1 2Mb 10ms DropTail
$ns duplex-link $n1 $r1 2Mb 10ms DropTail
$ns duplex-link $r1 $r2 1.7Mb 20ms DropTail
$ns duplex-link $r2 $n2 2Mb 10ms DropTail
$ns duplex-link $r2 $n3 2Mb 10ms DropTail

#Set Queue size of link (r1-r2) to 10
$ns queue-limit $r1 $r2 10

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
$tcp set class_ 2
$ns attach-agent $n0 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n2 $sink
$ns connect $tcp $sink
$tcp set fid_ 1

#Setup a FTP over TCP connection
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP

#Setup the second TCP connection
set tcp1 [new Agent/TCP]
$tcp1 set class_ 2
$ns attach-agent $n1 $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $n3 $sink1
$ns connect $tcp1 $sink1
$tcp1 set fid_ 2

#Setup a FTP over TCP
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ftp1 set type_ FTP

#Schedule Events
$ns at 0.1 "$ftp start"
$ns at 0.5 "$ftp1 start"
$ns at 25.0 "$ftp1 stop"
$ns at 25.5 "$ftp stop"

#Call finish procedure
$ns at 26.0 "finish"

#Run the simulation
$ns run
