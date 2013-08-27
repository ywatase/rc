/*
 * This is an example of options file for nodelint
 * They have been changed from the default to be better suited 
 * for browser based Javascript (node --> false, browser --> true)
 *
 * Changes released into the Public Domain by tav <tav@espians.com>
 * Options support added by Corey Hart <corey@codenothing.com>
 */

/*jslint indent: 4*/

var options = {
    "anon"       : false, // if the space may be omitted in anonymous function declarations
    "adsafe"     : false, // if ADsafe should be enforced
    "bitwise"    : true,  // if bitwise operators should not be allowed
    "browser"    : true,  // if the standard browser globals should be predefined
    "cap"        : false, // if upper case HTML should be allowed
    "confusion"  : false, // if types can be used inconsistently
    "continue"   : true,  // if the continuation statement should be tolerated
    "css"        : false, // if CSS workarounds should be tolerated
    "debug"      : false, // if debugger statements should be allowed
    "devel"      : false, // if logging should be allowed (console, alert, etc.)
    "eqeq"       : false, // if the == should be allowed
    "es5"        : true,  // if ES5 syntax should be allowed
    "evil"       : false, // if eval should be allowed
    "forin"      : true,  // if for in statements need not filter
    "fragment"   : false, // if HTML fragments should be allowed
    "indent"     : 2,     // set the expected indentation level
    "maxerr"     : 50,    // the maximum number of errors to allow
    "maxlen"     : 100,   // the maximum length of a source line
    "newcap"     : false, // if constructor names capitalization is ignored
    "node"       : true,  // if Node.js globals should be predefined
    "nomen"      : true,  // true, if names may have dangling _
    "on"         : false, // if HTML event handlers should be allowed
    "passfail"   : false, // if the scan should stop on first error
    "plusplus"   : true,  // if increment/decrement should be allowed
    "properties" : false, // if all property names must be declared with /*properties*/
    "regexp"     : true,  // if the . should be allowed in regexp literals
    "rhino"      : false, // if the Rhino environment globals should be predefined
    "undef"      : false, // if variables can be declared out of order
    "unparam"    : true,  // if unused parameters should be tolerated
    "safe"       : false, // if use of some browser features should be restricted
    "sloppy"     : true,  // if the 'use strict'; pragma is optional
    "sub"        : false, // if all forms of subscript notation are tolerated
    "vars"       : false, // if multiple var statements per function should be allowed
    "white"      : false, // if sloppy whitespace is tolerated
    "widget"     : false, // if the Yahoo Widgets globals should be predefined
    "windows"    : false, // if MS Windows-specific globals should be predefined

    // the names of predefined global variables:
    "predef"     : [
        '$',
        '$$',
        'Event',
    ],

    // customise the error reporting -- the following colours the text red
    "error_prefix" : "\u001b[1m",
    "error_suffix" : ":\u001b[0m "
};
