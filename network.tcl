#Create a simulator object
set ns [new simulator]

#Define colours for dataflows
$ns color 1 Green
$ns color 2 Blue

#Open the nam trace file
set nf [open out.nam w]
$ns namtrace-all $nf

#Define a 'finish' procedure
proc finish{} {
	global ns nf
	$ns flush-trace

	#Close the trace file
	close $nf

	#Execute nam on the trace file
	exec nam out.nam $
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
$ns simplex-link $n0 $r1 10Mb 10ms DropTail
$ns simplex-link $n1 $r1 10Mb 10ms DropTail
$ns simplex-link $r1 $r2 5Mb 20ms DropTail
$ns simplex-link $r2 $n2 10Mb 10ms DropTail
$ns simplex-link $r2 $n3 10Mb 10ms DropTail

#Node position for NAM
$ns simplex-link-op $n0 $r1 orient right-down
$ns simplex-link-op $n1 $r1 orient right-up
$ns simplex-link-op $r1 $r2 orient right
$ns simplex-link-op $r2 $n2 orient right-up
$ns simplex-link-op $r2 $n3 orient right-down

#Set a label to the bottleneck link
$ns simplex-link-op $r1 $r2 label "Bottleneck-Link"

#Monitor the queue of the bottleneck link
$ns simplex-link-op $r1 $r2 queuePos 0.5







