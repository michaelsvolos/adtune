var tabId = null;
var isPlaying = false;
var volume = 10;

chrome.tabs.query({
  currentWindow: true,
  active: true
}, function(tabs) {
  tabId = tabs[0].id;
});

$(document).ready(function() {
  var btn = $(".button");
  btn.click(function() {
    btn.toggleClass("paused");

    chrome.tabs.sendMessage(tabId, {
      action: 'playpause',
    }, function(data) {
      isPlaying = data.isPlaying;
      volume = data.volume;
    });

    return false;
  });

  chrome.tabs.sendMessage(tabId, {
    action: '',
  }, function(data) {
    isPlaying = data.isPlaying;
    volume = data.volume;

    if (isPlaying) {
      btn.toggleClass("paused");
    }

    var slider = document.getElementById("volume");
    var volumeLabel = document.getElementById("volume-label");
    slider.value = volume;
    volumeLabel.innerText = volume;
  });
});

var slider = document.getElementById("volume");
var volumeLabel = document.getElementById("volume-label");
slider.oninput = function() {
  volumeLabel.innerText = this.value;

  console.log('sending volume message', tabId);
  chrome.tabs.sendMessage(tabId, {
    action: 'volume',
    volume: this.value,
  }, function(data) {
    isPlaying = data.isPlaying;
    volume = data.volume;
  });
};
