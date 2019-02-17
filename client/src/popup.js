/*
This file defines logic for the chrome extension popup window.
Enables play/pause and volume controls.
 */

// Globals
var tabId = null;
var isPlaying = false;
var volume = 10;
var adCount = null;

// Get the current window's tabId.
chrome.tabs.query({
  currentWindow: true,
  active: true
}, function(tabs) {
  tabId = tabs[0].id;
});

// On document load, enable components
$(document).ready(function() {
  var btn = $(".button");

  // Play/pause functionality, send message to content.js
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

    return false; // Disable submit for the button;
  });

  // Query content.js for current state and update UI.
  chrome.tabs.sendMessage(tabId, {
    action: '',
  }, function(data) {
    // Update state variables.
    if (data) {
      isPlaying = data.isPlaying;
      volume = data.volume;
      adCount = data.adCount;
    }

    // Set play/pause button to correct starting value.
    if (isPlaying) {
      btn.toggleClass("paused");
    }

    // Update slider value and label.
    var slider = document.getElementById("volume");
    var volumeLabel = document.getElementById("volume-label");
    slider.value = volume;
    volumeLabel.innerText = volume;

    // Update ad-count label.  Default message if we don't have a count yet.
    var adCountLabel = document.getElementById('ad-count');
    if (adCount) {
      adCountLabel.innerText = 'number of ads on this page: ' + adCount;
    } else {
      adCountLabel.innerText = 'Interact with the page to load.';
    }
  });
});


// Volume slider functionality.
var slider = document.getElementById("volume");
var volumeLabel = document.getElementById("volume-label");
slider.oninput = function() {
  volumeLabel.innerText = this.value;

  chrome.tabs.sendMessage(tabId, {
    action: 'volume',
    volume: this.value,
  }, function(data) {
    isPlaying = data.isPlaying;
    volume = data.volume;
    adCount = data.adCount;
  });
};
