package main

import (
	"fmt"
   "os"
	"time"
	"strconv"
)

//globals

var invaders = [][]bool{ 
	{false,false,false,true,true,true,false,}, 
	{false,false,true,true,false,false,false,}, 
	{false,true,true,true,true,true,false,}, 
	{true,true,true,false,true,false,false,}, 
	{false,true,true,true,true,false,false,}, 
	{false,true,true,true,true,false,false,}, 
	{false,true,true,true,true,false,false,}, 
	{true,true,true,false,true,false,false,}, 
	{false,true,true,true,true,true,false,}, 
	{false,false,true,true,false,false,false,}, 
	{false,false,false,true,true,true,false,},
	{false,false,true,true,true,false,false,}, 
	{false,false,true,true,true,false,true,}, 
	{false,true,true,true,true,true,false,}, 
	{true,true,true,false,true,false,false,}, 
	{true,true,true,true,true,true,false,}, 
	{true,true,true,true,true,true,false,}, 
	{true,true,true,false,true,false,false,}, 
	{false,true,true,true,true,true,false,}, 
	{false,false,true,true,true,false,true,},
	{false,false,true,true,true,false,false,},
	{false,false,true,true,true,false,false,}, 
	{false,false,true,true,false,false,true,}, 
	{false,true,true,true,false,true,false,}, 
	{false,true,false,true,true,false,true,}, 
	{true,true,true,true,false,true,false,}, 
	{true,true,true,true,false,true,false,}, 
	{false,true,false,true,true,false,true,}, 
	{false,true,true,true,false,true,false,}, 
	{false,false,true,true,false,false,true,},
	{false,false,true,true,true,false,false,}, }

func testInvader(wo int, do int){
//print the invader patterns to the console

	for d:=0; d<=6; d++ {
		for w:=0; w<=30; w++ {
			if d==do && w==wo {
				fmt.Print("T")
			}else if invaders[w][d] {
				fmt.Print("#")
			}else{
				fmt.Print(" ")
			}
		}
		fmt.Println()
	}
}

func main() {

var start, today, weekOffset, dayOffset int


// Deal with input
if len(os.Args) > 1 {
	start,_=strconv.Atoi(os.Args[1])
}else{
	fmt.Println("error: need start time in epoc seconds for arg1")
	os.Exit(42)
}

if len(os.Args) > 2 {
	today,_=strconv.Atoi(os.Args[2])
}else{
	t:=time.Now()
	today=int(t.Unix())
}
startTime:=time.Unix(int64(start),0)
todayTime:=time.Unix(int64(today),0)

if todayTime.Before(startTime){
	fmt.Println("Error: Start time must precede End time")
	os.Exit(42)
}

daysPerWeek := 7
daysTot := len(invaders)*len(invaders[0])
daysSinceStart := (todayTime.Sub(startTime)/(time.Hour*24))

if (int(daysSinceStart) <= daysTot){
	weekOffset = (int(daysSinceStart) / daysPerWeek)
	dayOffset = (int(daysSinceStart) % daysPerWeek)
}else{
	effectiveDaysSinceStart := (int(daysSinceStart) % daysTot)
	weekOffset = effectiveDaysSinceStart / daysPerWeek
	dayOffset = effectiveDaysSinceStart % daysPerWeek
}

fmt.Printf("start: %d, today %d, daysSinceStart: %d\n",start, today, daysSinceStart)
fmt.Printf("daystot: %d\n", daysTot)

testInvader(weekOffset, dayOffset )

if invaders[weekOffset][dayOffset] { 
	fmt.Println("returning true")
	os.Exit(0)
}else{
	fmt.Println("returning false")
	os.Exit(1)
}
}
