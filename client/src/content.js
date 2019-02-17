/*
This file is injected into each webpage.  This file is responsible for
querying the server for an audio file and playing the file.
 */


// Globals
var audioUrl = null;
var stopPlaying = false;
var volume = 1.0;
var audio = null;
var adCount = null;

// When the window is loaded, get .wav path from server.
$(window).on('load', function() {
  var currentURL = {
    url: window.location.href
  };

  chrome.runtime.sendMessage({
    method: 'POST',
    action: 'xhttp',
    url: 'http://104.40.74.37:5000/create_music/',
    data: JSON.stringify(currentURL)
  }, function(data, status) {
    adCount = data.count;

    // When the user interacts with the window, start playing.
    // Chrome autoplay policy doesn't let us auto-play until then.
    $(window).click(function() {
      if (!audio) {
        play(data.filename, true);
      }
    });
  });
});

// A promise wrapper for audio objects.
// Supports infinite looping with the `loop` boolean argument.
function play(filename, loop) {
  return new Promise(function(resolve, reject) { // return a promise
    audio = new Audio(); // create audio wo/ src
    audio.preload = "auto"; // intend to play through
    audio.autoplay = true; // autoplay when loaded
    audio.onerror = reject; // on error, reject
    audio.onended = resolve; // when done, resolve
    audio.volume = volume;

    if (loop) {
      audio.addEventListener('ended', function() {
        this.currentTime = 0;
        console.log(stopPlaying, volume);
        if (!stopPlaying) {
          this.play();
        }
      }, false);
    }

    audio.src = "http://104.40.74.37:5000/wavs/" + filename;
  });
}

chrome.runtime.onMessage.addListener(function(request, sender, callback) {
  // Volume slider messages
  if (request.action == "volume") {
    volume = request.volume / 10.0;
    audio.volume = volume / 10.0;

  // Play/pause button messages
  } else if (request.action == 'playpause') {
    if (audio) {
      stopPlaying = !stopPlaying;
      if (stopPlaying) {
        audio.pause();
      } else {
        audio.play();
      }
    }
  }

  // Send content data to the extension.
  callback({
    isPlaying: !stopPlaying,
    volume: volume * 10,
    adCount: adCount
  });
  return true;
});
