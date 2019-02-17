# Adtune - a computer music-mediated reminder of just how many ads are out there

<!-- pitch -->

Adtune consists of a client chrome extension and a server written in Python/Flask.

A TreeHacks 2019 project.

## Requirements

-   jQuery
-   Google Chrome
-   Python 2.7
-   ChucK

See subdirectory READMEs for setup instructions.


## ChucK

What is ChucK?  How to install?

## How it works

We use server-side text-matching with known ad hosts as provided
by https://easylist.to/ to count the number of ads on a webpage.  

Based on this count, the server executes `ChucK` to create a `.wav` that
can be served as a static resource.  

The chrome extension creates a Javascript `Audio` object and injects it
into the webpage.  The file starts playing once the user interacts
with the webpage.  This is a constraint set by Chrome's autoplay
policies (TODO link).

The popup window of the chrome extension provides play/pause and volume control for this track.

## Examples

## Challenges

### Counting ads

We wanted Adtune to work regardless of whether the user had an Ad Blocker installed.  As a result, we chose to count ads on the server side.  If the user had an Ad Blocker installed, we would not have been able to detect removed ads from the chrome extension.   

Our method for identifying ads is rudimentary compared to industry Ad Blockers.  Our extension shows the number of ads we detect.  At times, this number varies greatly from other installed Ad Blockers.

### Creating audio files

It's a bit slow.  

### Controlling the audio track

We wanted the music to play regardless of whether our extension was opened.  Therefore, we had to inject the audio track into the webpage.  This caused different challenges in our ability to keep the extension popup's application state in sync with the injected content.
