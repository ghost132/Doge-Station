/*
 *	POST Request
 *
 *	1st arg				- the url
 *	2nd arg				- the request body
 *	3rd - nth arg		- headers("headername: value")
 *
 *	@return string		- response body
 */

/proc/POST()
	if(args.len < 2)
		return -1

	var/url = args[1]
	var/data = args[2]

	var/options = {"--proto =http,https --output "temp.html" --request POST "}

	for(var/i=3, i<=args.len, i++)
		options += {"-H "[args[i]]" "}

	options += {"-d "[data]""}

	shell("curl [options] [url]")

	var/rtn = file2text(file("temp.html"))
	fdel(file("temp.html"))
	return rtn