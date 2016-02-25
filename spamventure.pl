/* Spamventure! */
%% starter file by Ran Libeskind-Hadas
%% and modified by Z Dodds

/*



  Comments on your game should go here -- including how to "solve" it
     -- and anything else the graders should know (extras)
 win the game by discovering who killed the captain (actually there is much more to it than that but that would be spoilers)
 you have amnesia, so there is chance you might forget where you are and wind up in a mystery location!
 other features: use of a maybe (random probability) to determine when you get lost
 note that I commented this feature out because its actually really annoying.  The code is still there to see how it works
 items can be used, and their ability to be used depends on location
 items can be dropped
 dyanmic environment description based on whether or not you have visited the location and what you have done there 
 (i.e used items)
 I got a little bit carried away with this so it is kind of a mess
 How to win:
 The long way:
 take(lockbox).
 north.
 use(ftdevice).
 take(flare).
 use(flare).
 south.
 west.
 take(toolkit).
 use(toolkit).
 take(magnetopinpointer).
 east.
 east.
 east.
 south.
 take(gammasword).
 north.
 north.
 take(hololog).
 south.
 west.
 west.
 south.
 south.
 south.
 use(magnetopinpointer).
 use(safebox).
 use(hololog).
 north.
 north.
 Then you win!

 The short way:
 assert(thing_at(gammasword,in_hand)).
 assert(used(hololog)).
 south.
 Then you win!







*/



% some "nice" prolog settings...  see assignment 8's
% description for the details on what these do
% -- but it's not crucial to know the details of these Prolog internals
:- set_prolog_flag( prompt_alternatives_on, groundness ).
:- set_prolog_flag(toplevel_print_options, [quoted(true), 
     portray(true), attributes(portray), max_depth(999), priority(699)]).



%% thing_at(X, Y) will be true iff thing X is at location Y.
%% player_at(X) will be true iff player is at location X.
%% The use of dynamic should be at the beginning of the file when
%% we plan to mix static and dynamic facts with the same names.

:- dynamic thing_at/2, player_at/1, used/1, visited/1, carrying/1, size/1.

%% The player is initially at campsite
player_at(camp).

%% thing_at(X, Y) is true iff thing X is at location Y.

thing_at(lockbox, camp).  
thing_at(flare,cliff).
thing_at(toolkit, village).
thing_at(rations, camp).
thing_at(aminogel, camp).
thing_at(flag, camp).
thing_at(plasma, hull).
thing_at(cookie, hull).
thing_at(starmap, cabins).
thing_at(spam, cabins).
thing_at(hololog, cockpit).
thing_at(gammasword, cabins).

describe_item(rations) :- write('There are rations on the ground.  These could run out quickly if help is not found soon.').
describe_item(aminogel) :- player_at(Place),write('Amino gel is a thick, blue gel that can has potent healing powers.  You see some at the '), write(Place).
describe_item(flag) :- player_at(Place), write('You see a black and gold flag at '), write(Place), nl, 
write('It is a symbol of your homeworld, Spamalon III').
describe_item(plasma) :-write('You see a tube of plasma on the ground').
describe_item(cookie) :- write('There is a container of yummy cookies.').
describe_item(starmap) :- write('You see a starmap with information on the nearby solar system.').
describe_item(spam) :- write('There is a container packed with spam.').
describe_item(hololog) :-write('You see a hololog- it has records of the past events on the Spammemium Falcon').
describe_item(gammasword) :-write('There is a gamma sword on the ground.').

%% Items have actions

action(flare) :-
retract(thing_at(flare, in_hand)),
write('You set off the flare. For a time, the entire crew is distracted and confused. Now is the perfect time to investigate things further.').

action(lockbox) :-
assert(thing_at(ftdevice, in_hand)),
write('You open up the lockbox and find a device perfect for computing Fourier transforms'), nl,
write('It is odd that Jane would have this device. Rain is the only engineer on the ship and only he would need it.'), nl,
write('You now have '),
write(ftdevice),
nl.

action(ftdevice) :-
retract(thing_at(ftdevice, in_hand)),
player_at(cliff),
write('You give the fourier tranform device to Rain.  He promises to repair the radio as fast as he can and try to contact help'), nl,
nl.

action(ftdevice) :-
\+player_at(cliff),
retract(used(ftdevice)),
write('You cannot use that item here').

action(toolkit) :-
player_at(Place),
write('You dump the items in the toolkit at your current location, the '), write(Place), nl,
write('Items:'), nl,
write('magnetopinpointer, quantum circuitboard (type qcb), beta ray gun (type brg), and gammawrench'), nl, 
write('You can take these things from your current location now.'),
assert(thing_at(magnetopinpointer, Place)),
assert(thing_at(gammasword, Place)),
assert(thing_at(qcb, Place)).

action(magnetopinpointer) :-
player_at(grove),
write('You locate a metal safebox buried in the ground.'),nl,
write('It is your own personal safebox.  What could it be doing here?'),nl,
write('You have no memory of burying it here.'), nl, 
write('You now have safebox'), nl,
assert(thing_at(safebox, in_hand)).

action(magnetopinpointer) :-
\+player_at(grove),
write('You are not getting any readings from the magnetopointer here.').

action(safebox) :-
write('You open up the safebox'),nl,
write('In it there are many of your personal belongings'), nl,
write('Among them, a container of cyanohydride.  The same cyanohydride that was used to kill Captain Spammicus'),nl,
write('Suddenly a flood of memories rush onto you.  You entering the sleeping quarters of Spammicus'), nl,
write('Vivid images of adding droplets of cyanohydride into the spam that the Captain would later eat for breakfast'), nl,
write('Horrified, you realize that you are the mutineer.  But why would you do such a thing?'),nl,
write('You find the codes to a hololog that would be on the Spammemium Falcon.  That probably contains more clues.').

action(hololog) :-
used(safebox),
write('You activate the hololog.  A hologram of Captain Spammicus appears, dated the night before the crash'), nl,
write('He informs you that the crew is approaching the planet possessed by the dark forces of the evil Spammazon.'), nl,
write('These forces must have taken control of your mind and killed Captain Spammicus in your body.'), nl,
write('Captain Spammicus talks of an ancient temple that the spirit of Spammazon resides in.  This must be the temple south of the camp.'), nl,
write('The Spammazon is weak against Gamma energy.  Use the gamma sword to slay the Spammazon').

action(hololog) :-
\+used(safebox),
retract(used(hololog)),
write('The holog will not activate.  You need to find the activation codes.  You recall that they are in your personal safebox').


%% path(X, Y, Z) is true iff there is a path from X to Z via direction Y.
path(camp, north, cliff).   
path(camp, east, crash).
path(camp, south, temple).
path(camp, west, village).

path(village, east, camp).

path(cliff, south, camp).

path(crash, west, camp).
path(crash,east, hull).

path(temple, north, camp).
path(temple, south, door).

path(grove, north, tunnel).

path(tunnel, north, door).
path(tunnel, south, grove).

path(door, north, temple).
path(door, south, tunnel).


path(hull,west, crash).
path(hull, north, cockpit).
path(hull, south, cabins).

path(cabins, north, hull).

path(cockpit, south, hull).

%The player can display their inventory at any time

inventory:-thing_at(Thing, in_hand), write(Thing), nl, fail.

% The amount of things the player can have in their inventory is limitied
size(0).
inc :- size(OldSize), NewSize is OldSize +1, retract(size(OldSize)), assert(size(NewSize)).
full :- size(Size), Size > 5, write('You are over-encumbered.').

%Display how many things you are carrying by typing capacity.

capacity :- size(Size), write('Inventory capacity: '), write(Size), write('/5').

%% This is how one can take an object.
%% There might be barriers to taking an object that you have to remove
barrier(flare) :- \+used(ftdevice).
barrier(toolkit) :- \+used(flare).




take(X) :- 
    \+barrier(X),
    thing_at(X, in_hand),
    nl, write('You are already holding that.'),
    nl.  /* new line */

take(X) :-
    \+barrier(X),
    inc,
    \+full,
    player_at(Place),
    thing_at(X, Place),
    retract(thing_at(X, Place)),
    assert(thing_at(X, in_hand)),
    nl, write('OK you now have '),
    write(X), nl.

take(X) :-
    barrier(X),
    write('Trying to take '),
    write(X),
    write(' would be futile at the moment.').


drop(X) :-
    player_at(Place),
    thing_at(X, in_hand),
    retract(thing_at(X, in_hand)),
    assert(thing_at(X, Place)),
    write('You dropped'), nl,
    write(X), nl,
    write('at') ,nl,
    write(Place).


use(X) :-
    \+used(X),
    thing_at(X, in_hand),
    action(X),
    assert(used(X)).

use(X) :-
    used(X),
    write('You have already used '),
    write(X).
use(X) :-
    \+thing_at(X, in_hand),
    write('You do not have '),
    write(X).


%% This is how we move.
north :- go(north).
south :- go(south).
east :- go(east).
west :- go(west).
%10% chance of chance being true-this is used to randomly decided if you get lost!
chance :- maybe(0.1).

go(Direction) :-
    %% \+getLost this is how getLost works but I commented it out
    player_at(Here),
    path(Here, Direction, There),
    retract(player_at(Here)),
    assert(player_at(There)),
    assert(visited(There)),
    nl, write('You are now walking to the '),
    write(There), nl,
    look.

go(Direction) :-
    player_at(Here),
    \+path(Here, Direction, _),
    write('You cannot go that way.'), nl.

/*
getLost :- \+alreadyLost(grove),\+player_at(grove), player_at(Here), chance, retract(player_at(Here)), 
write('You got lost but do not remember what happened.  Your amnesia must be pretty bad.  The last thing you remember was walking from '),
write(Here), write(' but you veered off the path.'), nl,
write('You must have come here for a reason.  You do not remember why, but this is an important location. '), assert(player_at(grove)), look, assert(alreadyLost(grove)).

*/
%% The predicates used to describe a place
look :- nl, player_at(Place), describe(Place), nl.

directions:- player_at(Place), path(Place, Direction, Dest), write('The '), write(Dest), write(' is to the '), write(Direction), nl, fail.
describe_things(Place) :- thing_at(Thing, Place), describe_item(Thing), nl, fail.

describe(camp) :- 
    thing_at(lockbox, in_hand),
    write('You are in the campsite, approximately a kilometer west of the crashed spaceship.'), nl,
    write('Jane is still sitting on a log and staring pensively toward the crashsite'), nl,
    write('She still has not noticed that her lockbox has gone missing.  She must be extremely preoccupied.'),
    describe_things(camp).

describe(camp) :- 
    \+thing_at(lockbox, in_hand),
    write('You are in the campsite, approximately a kilometer west of the crashed spaceship.'), nl,
    write('Jane, a fellow member of your crew, is sitting on a log and staring pensively into the distance'), nl,
    write('You see a lockbox on the ground- it probably belongs to Jane'), nl,
    write('You realize you could easily snatch it without her noticing'),nl,
    describe_things(camp).

describe(cliff) :- 
    \+used(ftdevice),
    write('You have reached a cliffside overlooking a massive green valley of trees and rivers.'), nl,
    write('The chief technician, Rain, is fiddling with a radio device damaged in the crash.'), nl,
    write('He informs you that he wants a fourier transform --'), nl,
    write('and wants it fast!'), nl,
    write('You also notice a flare laying idly by the scrambled mess of equipment Rain is working on.  This could be useful for setting up a distraction.') ,nl,
    write('If you managed to get rain that Fourier transform he would probably be distracted long enough for you to snatch the flare.'), nl,
    describe_things(cliff).

describe(cliff) :- 
    used(ftdevice), thing_at(flare, in_hand),
    write('You have reached a cliffside overlooking a massive green valley of trees and rivers.'), nl,
    write('The chief technician, Rain, is fiddling with a radio device damaged in the crash.'), nl,
    write('There is not much to do here right now'),nl,
    describe_things(cliff).

describe(cliff) :- 
    used(ftdevice), 
    \+thing_at(flare, in_hand),
    write('You have reached a cliffside overlooking a massive green valley of trees and rivers.'), nl,
    write('The chief technician, Rain, is fiddling with a radio device damaged in the crash.'), nl,
    write('You also notice a flare laying idly by the scrambled mess of equipment Rain is working on.  This could be useful for setting up a distraction.') ,nl,
    write('You could easily snatch the flare because now Rain is so distracted doing fourier transforms.'), nl,
    describe_things(cliff).

describe(crash) :- 
    write('You have arrived at the site of the wrecked spaceship.'), nl,
    write('The crash was violent but not so much so that the ship is unenterable.'),nl,
    describe_things(crash).

describe(temple):-
    \+visited(temple),
    \+used(hololog),
    \+thing_at(gammasword, in_hand),
    write('You have arrived at an ancient temple in the forest.'), nl,
    write('The medic, Luna, is wandering the area, at once fascinated by this alien relic and attempting to distract herself from the pressing issues at hand.'), nl,
    write('Luna tells you that she believes Captain Spammicus was poisoned by spam laced with cyanohydride'), nl,
    write('You see a door to the south. You notice that the path has been used recently.'), nl, 
    describe_things(temple).

describe(temple):-
    visited(temple),
    \+used(hololog),
    write('You have arrived at the ancient temple in the forest.'), nl,
    write('Luna is pacing the premises.  There a door to the south, and a path back to campsite to the north'),nl,
    describe_things(temple).

describe(temple):-
    used(hololog),
    thing_at(gammasword, in_hand),
    write('You enter the temple and travel a long ways into its depths.'), nl,
    write('In the final chamber is the evil Spammazon.  You duel for one hour and after many close calls, you avenge Captain Spammicus and slay the evil spirit of Spammazon'), nl,
    write('Suddenly, the temple collapses.  You narrowly escape and run straight into the rescue spacecraft that Rain tracked down as the temple collapses around you.'),nl,
    write('The end!').

describe(temple):-
    used(hololog),
    \+thing_at(gammasword, in_hand),
    write('You will need the gamma sword to defeat the Spammazon.'), nl,
    describe_things(temple).


describe(hull) :- 
    write('This is the hull of the ship.  The damage is bad.  You stumble through a treacherous wreck of sparking wires and burnt, twisted metal.'), nl,
    describe_things(hull).

describe(cockpit) :-
    write('You arrive at the cockpit. The windows are smashed in and leaves from the outside litter the ground. '), nl,
    describe_things(cockpit).

describe(cabins) :-
    write('These are the cabins where the crew lived.'), nl,
    describe_things(cabins).


describe(village):-
    \+used(flare),
    write('You have found a village.'), nl,
    write('It is small and whatever species lived here at one point was likely fairly primitive.'), nl,
    write('The weapons expert, Cliff, is investigating the premise.  You wonder if he is hiding anything.'), nl,
    write('You notice he is keeping his toolkit close by.  You could probably retrieve it from him if you set up a distraction.'),nl,
    describe_things(village).

describe(village):-
    used(flare),
    write('You have arrived at the village.'), nl,
    write('The weapons expert, Cliff, is distracted by the flare.  You could take his toolkit.'), nl,
    describe_things(village).

describe(grove):-
    \+thing_at(magnetopinpointer,in_hand),
    \+thing_at(safebox, in_hand),
    \+visited(grove),
    write('You are in a serene grove.'),nl,
    write('It seems oddly familiar but you do not know why.  There is something important about this place'), nl,
    write('There is a secret tunnel to the north.  It looks like it has been used recently.'), nl,
    describe_things(grove).

describe(grove):-
    \+thing_at(safebox, in_hand),
    visited(grove),
    write('You are in the grove.'),nl,
    write('What is up with this place?'), nl,
    describe_things(grove).

describe(grove):-
    thing_at(magnetopointer, in_hand),
    write('The magnetopointer is beeping like crazy. Use it to track down what is causing the signal.'), nl,
    describe_things(grove).

describe(tunnel) :-
    write('The tunnel is dark and long and looks like it extends a long way.').

describe(door) :-
    write('You see a musty door.  Going south would take you into the tunnel and going north would take you out.  ').


%% notice that there is a problem here...
%% the can of spam is described in the description
%% of West dorm - but this means that it will
%% still be present in the description even 
%% after being picked up!
%%
%% this may be a good thing to fix to get you started!
%%


%% The predicates used to start the game
%% You should customize these instructions to reveal
%% the object of your adventure along with any special 
%% commands the user might need to know.
start :- instructions, look.

instructions :- nl,
    write('Welcome to Spamventure!'), nl,
    write('You are a member of the crew of the Spammenium Falcon that has crash landed on a lush foresty moon in a galaxy far, far away.'), nl,
    write('The landing was violent and you have woken up in a campsite outside the ship with retrograde amnesia and no memories of the events preceding the crash'), nl,
    write('All 4 of your crewmates are alive except for one: Captain Spammarticus.  You know that his favorite meal, spam, was poisoned and you suspect the crash was a ploy to make it look like an accident') ,nl,
    write('Suspicions of mutiny are overcoming the crew and you must figure out how the captain died before chaos unfolds'), nl,
    write('Type east, west, north, or south to move.'), nl,
    write('Type directions. to get a list of all the places you can go to form your current location'),nl,
    write('Type take(item) to take item.'), nl,
    write('Type inventory. to view the items you are currently holding.  You can only hold 5 items at once.'), nl,
    write('Type capacity. to display how many items you are holding.  If you try to take an item you will be notified that you are over-encumbered and must drop an item.'), nl,
    write('Type drop(item) to drop an item at your current location'),nl,
    write('Type use(item) to use the item.  Uses of items include giving items to people, activating items, opening items, and other general purposes that are context specific.'), nl.


