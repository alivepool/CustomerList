# ProudestAchievement

Once I had to implement data communication between iPhone(iOS) and system (Mac and Windows) via USB. The requirement was urgent and had to be done over a weekend.

Went through all the unofficial documentation for "usbmuxd" and how the communication happens.
Created a daemon for Mac and Windows communication and a library on iOS side with all the api and behavior required. This was for an IDE and on fly app update. Also has to implement javascript FFI from the iOS library. Later the daemon was ported to Golang.

Learnt many things, how the iOS communicates via USB, how to expose native library to javascript etc.
Was an interesting and hard task given the time frame.

