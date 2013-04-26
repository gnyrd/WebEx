WebEx
=====

Dispatches http(s) requests to specific browsers based on URL.


Setup
-----

Create a text file in ~/Library/Preferences/com.bithaus.weberal-express.plist

and write into it something like:

	<?xml version="1.0" encoding="UTF-8"?>
	<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
	<plist version="1.0">
	<dict>
		<key>httpDefault</key>
		<string>com.apple.safari</string>
		<key>httpsDefault</key>
		<string>com.apple.safari</string>
		<key>sites</key>
		<dict>
			<key>www.youtube.com</key>
			<string>com.google.Chrome</string>
			<key>youtu.be</key>
			<string>com.google.Chrome</string>
			<key>youtube.com</key>
			<string>com.google.Chrome</string>
		</dict>
	</dict>
	</plist>

and Bob's yer uncle.
