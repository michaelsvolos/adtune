chrome.runtime.onInstalled.addListener(function() {});  // Triggers adding other listeners

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
