package main

import (
	"fmt"
	"os"

	"github.com/ajstarks/svgo"
)

var width = 312
var height = 390 / 4
var waves = 4
var padding = 2 * width / waves
var waveHeight = 15

func drawWaves(width, height, offsetX, offsetY, waveHeight, waves int) string {
	s := fmt.Sprintf("M %d %d", offsetX, offsetY)
	waveWidth := width / waves
	ox := offsetX
	for i := 0; i < waves; i++ {
		controlX := ox + waveWidth/2
		s += fmt.Sprintf("C %d %d %d %d %d %d", controlX, offsetY-waveHeight, controlX, offsetY+waveHeight, ox+waveWidth, offsetY)
		ox += waveWidth
	}
	s += fmt.Sprintf("L %d %d L %d %d z", offsetX+width, offsetY+height, offsetX, offsetY+height)
	return s
}

func animate(frames int) {
	os.RemoveAll("waves/svg")
	os.Mkdir("waves/svg", os.ModePerm)

	animateStandingWave(frames)
	animateToBottom(frames*2 - (waveHeight*frames*2)/height)
	animateFromTop((waveHeight * frames * 2) / height)
}

func animateStandingWave(frames int) {
	var offsetX = -width / 4
	var offsetX2 = offsetX / 2

	distX := (1 * width) / (1 * waves * frames)
	remainderX := (1 * width) % (1 * waves * frames)

	for i := 0; i < frames; i++ {
		filename := fmt.Sprintf("waves/svg/wave-standing%d.svg", i)
		frame, err := os.OpenFile(filename, os.O_CREATE|os.O_WRONLY, os.ModePerm)
		if err != nil {
			panic(err)
		}

		canvas := svg.New(frame)
		canvas.Start(width, height)
		canvas.Rect(0, 0, width, height)
		canvas.Path(drawWaves(width+padding, height, offsetX, waveHeight, waveHeight, waves+2), "fill:rgb(149,214,255)")
		canvas.Path(drawWaves(width+padding, height, offsetX2, waveHeight, waveHeight, waves+2), "fill:rgb(72,185,255)")
		canvas.End()

		offsetX += distX
		offsetX2 -= distX
		if remainderX > 0 {
			offsetX += 1
			offsetX2 -= 1
			remainderX -= 1
		}
	}
}

func animateToBottom(frames int) {
	var offsetX = -width / 4
	var offsetX2 = offsetX / 2
	var offsetY = 4

	distX := (1 * width) / (1 * waves * frames)
	remainderX := (1 * width) % (1 * waves * frames)

	distY := (height - waveHeight) / frames
	remainderY := (height - waveHeight) % frames

	for i := 0; i < frames+1; i++ {
		filename := fmt.Sprintf("waves/svg/wave-to-bottom%d.svg", i)
		frame, err := os.OpenFile(filename, os.O_CREATE|os.O_WRONLY, os.ModePerm)
		if err != nil {
			panic(err)
		}

		canvas := svg.New(frame)
		canvas.Start(width, height)
		canvas.Rect(0, 0, width, height)
		canvas.Path(drawWaves(width+padding, height, offsetX, waveHeight+offsetY, waveHeight, waves+2), "fill:rgb(149,214,255)")
		canvas.Path(drawWaves(width+padding, height, offsetX2, waveHeight+offsetY, waveHeight, waves+2), "fill:rgb(72,185,255)")
		canvas.End()

		offsetX += distX
		offsetX2 -= distX
		if remainderX > 0 {
			offsetX += 1
			offsetX2 -= 1
			remainderX -= 1
		}

		offsetY += distY
		if remainderY > 0 {
			offsetY += 1
			remainderY -= 1
		}
	}
}

func animateFromTop(frames int) {
	var offsetX = -width / 4
	var offsetX2 = offsetX / 2
	var offsetY = 0

	distX := (1 * width) / (1 * waves * frames)
	remainderX := (1 * width) % (1 * waves * frames)

	distY := (waveHeight) / frames
	remainderY := (waveHeight) % frames

	for i := 0; i < frames; i++ {
		filename := fmt.Sprintf("waves/svg/wave-from-top%d.svg", i)
		frame, err := os.OpenFile(filename, os.O_CREATE|os.O_WRONLY, os.ModePerm)
		if err != nil {
			panic(err)
		}

		canvas := svg.New(frame)
		canvas.Start(width, height)
		canvas.Rect(0, 0, width, height)
		canvas.Path(drawWaves(width+padding, height, offsetX, offsetY, waveHeight, waves+2), "fill:rgb(149,214,255)")
		canvas.Path(drawWaves(width+padding, height, offsetX2, offsetY, waveHeight, waves+2), "fill:rgb(72,185,255)")
		canvas.End()

		offsetX += distX
		offsetX2 -= distX
		if remainderX > 0 {
			offsetX += 1
			offsetX2 -= 1
			remainderX -= 1
		}

		offsetY += distY
		if remainderY > 0 {
			offsetY += 1
			remainderY -= 1
		}
	}
}

func main() {
	animate(10)
}
