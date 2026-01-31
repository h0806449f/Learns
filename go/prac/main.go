package main

import "fmt"

func main() {
    messagesFromDoris := []string{
        "You doing anything later??",
        "Did you get my last message?",
        "Don't leave me hanging...",
        "Please respond I'm lonely!",
	}
    numMessages := float64(len(messagesFromDoris))
    costPerMessage := 0.02

    // don't touch above this line
	
    totalCost := costPerMessage * numMessages

	fmt.Printf("Doris spent $%.2f on text message today", totalCost)
}