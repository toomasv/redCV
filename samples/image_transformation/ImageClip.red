Red [
	Title:   "Flip tests "
	Author:  "Francois Jouen"
	File: 	 %Imageclip.red
	Needs:	 'View
]

; required libs
#include %../../libs/core/rcvCore.red
#include %../../libs/matrix/rcvMatrix.red
#include %../../libs/tools/rcvTools.red
#include %../../libs/imgproc/rcvImgProc.red

margins: 10x10
winBorder: 10x50
img1: rcvCreateImage 512x512
dst:  rcvCreateImage img1/size
rLimit: 0x0
lLimit: 512x512
start: 0x0
end: start + 200
poffset: negate start

canvas: none

loadImage: does [
	canvas/image/rgb: black
	tmp: request-file
	if not none? tmp [
		img1: rcvLoadImage tmp
		dst:  rcvCloneImage img1
		canvas/image: dst
		img1: to-image canvas ; force image in 512x512 size
		drawBlk: rcvClipImage poffset start end img1
		drawRect: compose [line-width 2 pen green box 0x0 200x200]
		p1/draw: [] ROI/draw: []
	]
]



; ***************** Test Program ****************************
view/tight [
		title "Clip Tests"
		style rect: base 255.255.255.240 202x202 loose draw []
		origin margins space margins
		button 90 "Load Image"		[loadImage]
		button 80 "Show Roi" 		[p1/draw: drawRect ROI/draw: drawBlk]
		button 80 "Hide Roi" 		[p1/draw: [] ROI/draw: []]
		button 80 "Quit" 	 		[rcvReleaseImage img1 dst Quit]
		return 
		canvas: base 512x512 dst react [	
			if (p1/offset/x > lLimit/x) AND (p1/offset/y > lLimit/y)[
				if (p1/offset/x  < rLimit/x) AND (p1/offset/y  < rLimit/y)[
					start: p1/offset - winBorder
					end: start + 200
					poffset: negate start
					sb/text: form start		
					drawBlk/2: poffset 
					drawBlk/4: start
					drawBlk/5: end
				]
			]
			
		]
		ROI: base 200x200 white draw []
		return
		sb: field 512
		at winBorder p1: rect
		do [rcvCopyImage img1 dst lLimit: canvas/offset rLimit: canvas/size + canvas/offset - p1/size ]
]
