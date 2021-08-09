# devmoe
A simple perl script to inject runes in the lol client
```
How it works

Makes lol API requests to determine selected champion for the user then do some rune page actions

Requirements

Strawberry Perl (32 bit preferably)

How to use

--cry_update.pl is self explanatory (it gets the latest runes.json and version.txt)
--cry_injector, runemap.json, runes.json, version.txt must be in the same dir 
1.Open lol client and login into your account
2.Disable premade runes (prevent current rune errors)
3.Keep at least 1 custom rune page and delete all others 
4.Run cry_injector.pl after confirming the champion at selection / joining the lobby (for ARAM)

Debug

If it doesn't work try running via cmd so you can see perl output

Any question? 
--no, it's not bannable, does the same shit as blitz, porofessor 
--it's not open code just because some idiot could mess around with my runes source

You can find me at 
my discord channel: https://discord.gg/4282y8EGxP id: awface#3260
my development blog: https://devmoe.blogspot.com/

Special thanks

zamanf for the perl base script
stirrante for the rune pages edit method
```
