###############################################################################################################
#
#                                       JSON Client Implementation in TCL
#
# Modules used : http
# Requires an input file to process the JSON request 
################################################################################################################

proc web_auth { URL url u username p password SSL ssl command com} {
    package require base64 ;# tcllib
    package require http   ;# tcl
    set auth "Basic [base64::encode $username:$password]"
	puts $auth
    set headerl [list Authorization $auth]
	puts $headerl
	puts $com
	if { $ssl == "true" } {
	package require tls
	::http::register https 443 ::tls::socket
	}
	set query "\"jsonrpc\":\"2.0\",\"method\":\"cli\",\"params\":\[\"$com\"\],\"id\":\"1\""
	puts "The JSON Query is $query\n"
	set http_mime "application/json"
	set tok [http::geturl $url -headers $headerl -query \{$query\} -type $http_mime]
	http::wait $tok
	puts $tok
	upvar #0 $tok state
    set res0 [http::data $tok]
	set res1 [::http::code $tok]
	set res2 [::http::error $tok]
	puts "The Output is  $res0\n"
	puts "The HTTP Code Received is $res1\n"
	puts "The HTTP Error if any is $res2\n"
    http::cleanup $tok
    return [list $res0 $res1 $res2]
	#return $res1 
	#return $res2
}

proc file_method { filename FILE output FILE1} {
	 set fp [open "$FILE" r]
     set file_data [read $fp]
     close $fp
     set data [split $file_data "\n"]
	 set fp1 [open "$FILE1" w]
     foreach line $data {
	 puts $fp1 "\n---------------------------------------------------------------------------------------------------------------------------------------------\n"
	 puts $fp1 $line
	 puts $fp1 "\n----------------------------------------------------------------------------------------------------------------------------------------------\n"
	 #puts $fp1 [web_auth URL "http://10.127.6.53/jsonrpc/" u admin1 p admin1 SSL false command "$line"]
	 #puts $fp1 [web_auth URL "https://10.127.6.53/jsonrpc/" u "admin" p "" SSL true command "$line"]
	 puts $fp1 [web_auth URL "https://10.127.6.57/jsonrpc/" u "admin" p "" SSL true command "$line"]
	 #puts $fp1 [web_auth URL "https://10.127.6.110/jsonrpc/" u admin1 p admin1 SSL on command "$line"]
    }
	 close $fp1
}   

proc replace_values { filename FILE output FILE1 value KEY} {
     set input $KEY
     set fp [open "$FILE" r]
     set file_data [read $fp]
     close $fp
     set data [split $file_data "\n"]
	 set data1 ""
	 set fp1 [open "$FILE1" w]
	 foreach line $data {
	 regsub -all "<" $line "" data1
	 regsub -all ">" $data1 "" data1
	 regsub  ".*:" $data1 "" data1
	 regsub  "\s*name" $data1 "v1" data1
	 regsub  "\s*list" $data1 "1:1-1:10" data1
	 regsub  "mac_address" $data1 "00:04:96:00:10:A0" data1
	 regsub  "hex" $data1 "0x0800" data1
	 regsub  "hex" $data1 "0x0801" data1
	 regsub  "hex" $data1 "0x8002" data1
	 regsub  "hex" $data1 "0x8003" data1
	 #regsub "filter_name" $data1 "v1" data1
	 puts $data1
	 puts $fp1 $data
     }
	 close $fp1
}   
#s![(^<)*]\S+!$input!mge	
 
#MAIN PROGRAM

file_method filename "D:\\JSON_RPC\\commands.txt" output "D:\\JSON_RPC\\output.txt"
#replace_values filename "D:\\JSON_RPC1\\commands1.txt" output "D:\\JSON_RPC1\\output1.txt" value "v1"
