var audioUrl = null;
var stopPlaying = false;
var volume = 1.0;
var audio = null;

$(window).on('load', function() {
  var currentURL = {
    url: window.location.href
  };

  chrome.runtime.sendMessage({
    method: 'POST',
    action: 'xhttp',
    url: 'http://104.40.74.37:5000/create_music/',
    data: JSON.stringify(currentURL)
  }, function(audioUrl, status) {

    $(window).click(function() {
      if (!audio) {
        play(audioUrl, true);
      }
    });
  });
});

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
  if (request.action == "volume") {
    volume = request.volume / 10.0;
    audio.volume = volume / 10.0;
    console.log('setting volume', volume);
  } else if (request.action == 'playpause') {
    stopPlaying = !stopPlaying;
    if (stopPlaying) {
      audio.pause();
      console.log('pausing');
    } else {
      audio.play();
      console.log('playing');
    }
  }
  callback({isPlaying: !stopPlaying,
            volume: volume * 10});
  return true;
});
