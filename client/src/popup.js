var tabId = null;
var isPlaying = false;
var volume = 10;
var adCount = null;

chrome.tabs.query({
  currentWindow: true,
  active: true
}, function(tabs) {
  tabId = tabs[0].id;
});

$(document).ready(function() {
  var btn = $(".button");
  btn.click(function() {
    chrome.tabs.sendMessage(tabId, {
      action: 'playpause',
    }, function(data) {
      if (isPlaying != data.isPlaying) {
        btn.toggleClass("paused");
      }
      isPlaying = data.isPlaying;
      volume = data.volume;
      adCount = data.adCount;
    });

    return false;
  });

  chrome.tabs.sendMessage(tabId, {
    action: '',
  }, function(data) {
    if (data) {
      isPlaying = data.isPlaying;
      volume = data.volume;
      adCount = data.adCount;
    }

    if (isPlaying) {
      btn.toggleClass("paused");
    }

    var slider = document.getElementById("volume");
    var volumeLabel = document.getElementById("volume-label");
    slider.value = volume;
    volumeLabel.innerText = volume;

    var adCountLabel = document.getElementById('ad-count');

    if (adCount) {
      adCountLabel.innerText = 'number of ads on this page: ' + adCount;
    } else {
      adCountLabel.innerText = 'Interact with the page to load.';
    }
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
    adCount = data.adCount;
  });
};
