$(window).on('load', function() {
  var currentURL = {
    url: window.location.href
  };

  chrome.runtime.sendMessage({
    method: 'POST',
    action: 'xhttp',
    url: 'http://104.40.74.37:5000/create_music/',
    data: JSON.stringify(currentURL)
  }, function(audio, status) {
    playAudio(audio, status);
  });
});

function playAudio(filename, status, jqxhr_object) {
  console.log(status);
  console.log(filename);
  var audio = new Audio("http://104.40.74.37:5000/wavs/" + filename);
  audio.load();
  audio.play();
}
