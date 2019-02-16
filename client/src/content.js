/* File: content.js
 * ---------------
 * Hello! You'll be making most of your changes
 * in this file. At a high level, this code replaces
 * the substring "cal" with the string "butt" on web pages.
 *
 * This file contains javascript code that is executed
 * everytime a webpage loads over HTTP or HTTPS.
 */

if(document.readyState === 'interactive') {
    // good to go!
    console.log("starting extension...");
    var currentURL = {url:window.location.href};
    console.log(currentURL);

    /*
    var xhr = new XMLHttpRequest();
    //xhr.onreadystatechange = handleStateChange; // Implemented elsewhere.
    xhr.open("POST", chrome.extension.getURL('/config_resources/config.json'), true);
    xhr.send();
    */

    /*
    $.ajax({
        type: "POST",
        url: "http://104.40.74.37:5000/create_music/",
        success: playFile,
        contentType: "application/json",
        data: JSON.stringify(currentURL)
    });
    */
    chrome.runtime.sendMessage({
        method: 'POST',
        action: 'xhttp',
        url: 'http://104.40.74.37:5000/create_music/',
        data: JSON.stringify(currentURL)
    }, function(audio) {
        playAudio(audio);
        /*Callback function to deal with the response*/
    });


    //$.post("https://104.40.74.37:5000/create_music/", JSON.stringify(currentURL), playFile);
    //console.log(status);

}   

/*
function playFile(filename, status, jqxhr_object) {
    console.log(status);
    console.log(filename);
    var audio = new Audio("http://104.40.74.37:5000/wavs/" + filename);
    audio.load();
    audio.play();
}
*/
/*
$("button").click(function(){
        $.post("http://104.40.74.37:5000/create_music/", currentURL, playFile(data, status));
    });
*/
//TODO
//finish post command
//figure out audio


/*
for (var i = 0; i < elements.length; i++) {
    var element = elements[i];

    for (var j = 0; j < element.childNodes.length; j++) {
        var node = element.childNodes[j];

        if (node.nodeType === 3) {
            var text = node.nodeValue;
            var replacedText = text.replace(/cal/gi, "butt"); // replaces "cal," "Cal", etc. with "butt"

            if (replacedText !== text) {
                element.replaceChild(document.createTextNode(replacedText), node);
              }
        }
    }
}
*/