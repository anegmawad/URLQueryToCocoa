URLQueryToCocoa
===============

Parses a Ruby-ish URL query string into Cocoa classes like `NSJSONSerializer`.

For example having the URL query string

    users[0][firstName]=Amin&users[0][lastName]=Negm&name=Devs&users[1][lastName]=Kienle&users[1][firstName]=Christian

you will get

    @{
       name : @"Devs",
       users :
       @[
         @{
           firstName = @"Amin",
           lastName = @"Negm"
         },
         @{
           firstName = @"Christian",
           lastName = @"Kienle"
         }
       ]
    }
    
You can set the key path pre- and postfixes ([]) and the delimiter between two assignments yo use the class for parsing both a GET query string and a POST form body.
