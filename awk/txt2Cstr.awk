
function clean(str) {
    sub(/[ \t]+$/,"",str);   # remove trailing whitespaces
	gsub(/\\/, "\\\\", str); # escape back slash
	gsub(/"/, "\\\"", str);  # escape double quotes
    return str;
}
function nuke_dot(str)
{
    split(str, a, ".");
    return a[1];
}

BEGIN {
	needsHeader = 1;
}
{
	if (needsHeader) {
		needsHeader = 0;
		
		print "/////////////////////////////////////////////"
		print "// CODE GENORATED BY AN AWK SCRIPT "
		print "/////////////////////////////////////////////"
		print ""
		print "const char * "  nuke_dot(FILENAME)  " = "
	}
	
	print "\t\"" clean($0) "\\n\""
}
END {
	print ";"
	print ""	
}