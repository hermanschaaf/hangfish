package main

import (
	"fmt"
	"os"

	"github.com/ajstarks/svgo"
)

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
	width := 312
	height := 390 / 4
	waves := 4
	padding := 2 * width / waves
	offsetX := -width / 4
	offsetX2 := offsetX / 2
	offsetY := height / 2
	waveHeight := 30

	os.RemoveAll("waves/svg")
	os.Mkdir("waves/svg", os.ModePerm)

	for i := 0; i < frames; i++ {
		filename := fmt.Sprintf("waves/svg/frame%d.svg", i)
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

		offsetX += 2 * (((width + padding) / (waves + 2)) / frames)
		offsetX2 -= 2 * (((width + padding) / (waves + 2)) / frames)
	}
}

func main() {
	animate(20)
}
