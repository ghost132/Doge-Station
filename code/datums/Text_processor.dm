proc/html2discord(text) //Converts the chat messages into markdown, used in the gamemodes.
	text = replacetext(text, "<B>", "**")
	text = replacetext(text, "</B>", "**")
	text = replacetext(text, "<FONT size = 3>", "")
	text = replacetext(text, "<FONT size = 2>", "")
	text = replacetext(text, "<font color='red'>", "*")
	text = replacetext(text, "<font color='green'>", "*")
	text = replacetext(text, "</font>", "*")
	text = replacetext(text, "</FONT>", "")
	text = replacetext(text, "<br>", "\n")
	text = replacetext(text, "<span class='big'>", "")
	text = replacetext(text, "</span>", "")
	return text