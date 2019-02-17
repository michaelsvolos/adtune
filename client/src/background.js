/*
This file defines a background routine for the chrome extension,
so that we can make normal HTTP requests from HTTPS webpages.
This command is invoked by content.js
 */

// Triggers adding other listeners
chrome.runtime.onInstalled.addListener(function() {});

chrome.runtime.onMessage.addListener(function(request, sender, callback) {
  if (request.action == "xhttp") {
    $.ajax({
      type: request.method,
      url: request.url,
      data: request.data,
      contentType: 'application/json',
      success: function(responseText) {
        callback(responseText, 'success');
      },
      error: function(XMLHttpRequest, textStatus, errorThrown) {
        //if required, do some error handling
        callback(textStatus, 'failed');
      }
    });
  }
  return true;
});
