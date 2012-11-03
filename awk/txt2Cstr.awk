
function rtrim(str) {
    #sub(/^[ \t]+/,"",str);  # remove leading whitespaces
    sub(/[ \t]+$/,"",str);  # remove trailing whitespaces
    return str;
}
function nuke_dot(str)
{
    split(str, a, ".");
    return a[1];
}

BEGIN {
	text = ""
}
{
	text = text "\t\"" rtrim($0) "\"\n"
}
END {
	print "/////////////////////////////////////////////"
	print "// CODE GENORATED BY AN AWK SCRIPT "
	print "/////////////////////////////////////////////"
	print ""
	print "const char * "  nuke_dot(FILENAME)  " = "
	print text ";"
	print ""	
}