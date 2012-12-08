
function clean(str) {
    sub(/[ \t]+$/,"",str);   # remove trailing whitespaces
	sub(/[ \t]*/,"",str);   # remove starting whitespaces
    return str;
}

function nuke_dot(str)
{
    split(str, a, ".");
    return a[1];
}


function readIdent( str )
{
	if (match(str, whiteSpaceRX)) { # skip whitespace
		str = substr(str, RSTART+RLENGTH);
		# print "trim " RSTART+RLENGTH " = " str;
	}
	if (match(str, identRX)) { # ident
		# print "Ident Match " RSTART " , " RLENGTH " : " substr(str, RSTART,RLENGTH);
		return clean( substr(str, RSTART,RLENGTH) );
	}
	return "";
}

function readType( str )
{
	if (match(str, whiteSpaceRX)) { # skip whitespace
		str = substr(str, RSTART+RLENGTH);
		# print "trim " RSTART+RLENGTH " = " str;
	}
	if (match(str, typeRX)) { # type
		# print "Type Match " RSTART " , " RLENGTH " : " substr(str, RSTART,RLENGTH);
		return clean( substr(str, RSTART,RLENGTH) );
	}
	return "";
}

function readDelim( str, delim )
{
	if (match(str, whiteSpaceRX delim)) { # skip whitespace
		str = substr(str, RSTART+RLENGTH);
		# print "delim " RSTART+RLENGTH " = " str;
	}
	
	return str;
}

function max( a, b )
{
	if (a > b) return a;
			   return b;
}

function nameMax( name, str )
{
	apis[ "max" name ] = max( apis[ "max" name ], length( str ) );
}

function parseLine( str )
{
	str = clean(str);
	
	if (length(str) == 0) return; #empty line, were done
	if (substr(str,1,2) == "//") return ; # comment line, dont process

	step = 0;
	lastEnd = 1;
	argc = 1;

	#
	# get return type
	#
	returnType = readType( str );
	str = substr(str, RSTART+RLENGTH);
	
	#
	# get name
	#
	name = readIdent( str );
	str = substr(str, RSTART+RLENGTH);
	
	str = readDelim( str, "[\(]" );
	
	use = "";
	dec = "";
	delim = "";

	
	keepGoing = 1;
	while (keepGoing) {

		argType = readType( str ); 
		
		if (argType != "") {
		
			str = substr(str, RSTART+RLENGTH);
			argName = readIdent( str ); str = substr(str, RSTART+RLENGTH);
			str = readDelim( str, "[,)][ \t]*" );

			# args[argc "name"] = argName;
			# args[argc "type"] = argType;
			# argc++;

			use = use delim argName ;
			dec = dec delim argType " " argName;
			delim = ", ";
			
			# print "Argc = " argc;
		} else {
			# print "exit loop " str ;
			keepGoing = 0;
		}
		
	}
	
	
	apis[ apiCount "name" ] = name;
	apis[ apiCount "return" ] = returnType;
	# api[ "args" ] = args;
	apis[ apiCount "use" ]  = use;
	apis[ apiCount "dec" ] = dec;
	
	nameMax( "name", name );
	nameMax( "return", returnType );
	nameMax( "use", use );
	nameMax( "dec", dec );
	
	# print step "=>" returnType "=>" name "=>" ":" ;
	
	#apis[ apiCount ] = api;
	apiCount++;
	
	# print "";
}

function emitComment( str )
{
	print "//";
	print "// " str;
	print "//";
}

BEGIN {
	apiCount = 1;
	
	apis[ "max" "name" ] = 0;
	apis[ "max" "return" ] = 0;
	apis[ "max" "use" ]  = 0;
	apis[ "max" "dec" ] = 0;

	
	whiteSpaceRX = "[ \t]*";
	identRX = "[a-zA-Z_][a-zA-Z_0-9]*";
	typeRX = identRX whiteSpaceRX "(*)*";

	parseMode = "parse";
}
{
	str = clean($0);
	if (str == "%%") {
		if (parseMode == "parse") {
			parseMode = "passThrough";
		} else {
			parseMode = "parse";
		}
	} else {
		if (parseMode == "parse") {
			parseLine($0);
		} else {
			print $0;
		}
	}
}
END {
	print "/////////////////////////////////////////////"
	print "// CODE GENORATED BY AN AWK SCRIPT "
	print "// appox"
	print "// cmd> awk -f api2c.awf " FILENAME
	print "/////////////////////////////////////////////"
	print ""


	interface = nuke_dot(FILENAME);
	Itype = interface "_t";
	IVTType = interface "VTable_t";

	emitComment( "Macros - if not already defined" );
	print "#ifndef HEADER_CODE";
	print "#define HEADER_CODE static";
	print "#endif//HEADER_CODE";
	print "";

	emitComment( "Types -- Forward declarations" );
	print "typedef struct " Itype " " Itype ";";
	print "typedef struct " IVTType " " IVTType ";";
	print "";

	emitComment( "Types -- Real declarations" );
	
	emitComment( "The Base Type" );
	print "struct " Itype " {"
	print "\t" IVTType " * VTable; // Must Be First"
	print "};"
	print ""
	
	emitComment( "The VTable" );
	print "struct " IVTType " {"
	for (i = 1; i < apiCount; i++)
	{
		rt = apis[i "return"];
		name = apis[i "name"];
		dec  = apis[i "dec"];
		
		if (dec != "") { dec = ", " dec }
		
		printf ("\t%-" apis["max" "return"] "s\t%-" apis[ "max" "name" ] + 10 "s\t%s\n", rt, "( * ptm_" name " )", "( " Itype " * _this_" dec " );" );
	}
	print "};"
	print ""
	
	emitComment( "Helper comment to Copy N Past" );
	print "/*****************************************";
	print "*** START Implimentation base for a 'foo' " interface;
	print "******************************************";
	print "typedef struct foo_" Itype " foo_" Itype ";" ;
	print "";
	print "struct foo_" Itype " {"
	print "\t" IVTType " * VTable;  // Must Be First"
	emitComment( "foo's members here" );
	print "};"
	print ""
	for (i = 1; i < apiCount; i++)
	{
		rt = apis[i "return"];
		name = apis[i "name"];
		dec  = apis[i "dec"];
		use	 = apis[i "use"];
		
		if (dec != "") { dec = ", " dec; use = ", " use; }
		if (rt == "void") { rc = ""; } else { rc = "return 0;"; }
		
		print "static " rt " foo_" name " ( " Itype " * _this_" dec " )"
		print "{"
		print "\tfoo_" Itype " * this = ( foo_" Itype " * ) _this_; "
		print "\t" rc 
		print "}"
		print ""
	}
	tail = ","
	print "static const " IVTType " imp_foo = {"
	for (i = 1; i < apiCount; i++)
	{
		name = apis[i "name"];
		if (i == apiCount-1) tail = "";
		
		print "\tfoo_" name tail ;
	}
	print "};"
	print ""
	print Itype " * foo_Create() "
	print "{"
	print "\tfoo_" Itype " * pNew = malloc( sizeof( foo_" Itype " ) );"  ;
	print "\tpNew->VTable = &imp_foo;" ;
	emitComment( "foo's init here" );
	print "\treturn ( " Itype " * ) pNew;" ;
	print "}";
	print "*****************************************";
	print "*** END Implimentation base for a 'foo' " interface;
	print "******************************************/";
	print ""
	
	emitComment( "Helper functions to use the base, and invoke the vtable" );
	for (i = 1; i < apiCount; i++)
	{
		rt = apis[i "return"];
		name = apis[i "name"];
		dec  = apis[i "dec"];
		use	 = apis[i "use"];
		
		if (dec != "") { dec = ", " dec; use = ", " use; }
		if (rt == "void") { rc = ""; } else { rc = "return "; }
		
		print "HEADER_CODE " rt " " interface "_" name " ( " Itype " * _this_" dec " )"
		print "{"
		print "\t" rc "( _this_->VTable->ptm_" name " )\t( _this_" use " );";
		print "}"
		print ""
	}
}