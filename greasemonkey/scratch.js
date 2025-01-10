// ==UserScript==
// @name     Unnamed Script 816693
// @version  1
// @grant    none
// @include https://www.patreon.com/*
// @require https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js

// ==/UserScript==

let paths = new Set();
let done = [];


setInterval(clickImages, 1000);
async function clickImages(){
    let selector = $( "img[class*='1h4huqp']" );
    selector.css('border', '5px solid red');
    for (let i = 0; i < selector.length; i++){
        let hash = selector[i].src.hashCode();
        if (done.includes(hash)) continue;
        done.push(hash);
        await delay(selector[i]).catch(() => {delete done[hash]});
    }
}

// A $( document ).ready() block.
$( document ).ready(function() {
    console.log( "ready!" );
    $(document).keypress(function(e) {
        if(e.which === 13) {
            let arr = [];
            for (let value of paths)
                arr.push(value);
            downloadObjectAsJson(arr, "patreon");
        }
    });
});

function doStuff(){
    let hoverBoxDiv = $( "div[class*='1z0k0vk']" );
    if (hoverBoxDiv.length !== 0) {
        hoverBoxDiv.css("display", "none");
        let foundIMG = hoverBoxDiv.find("img");
        paths.add(foundIMG[0].src);
        foundIMG[0].parentElement.click();
        return true;
    }
    return false;
}

const delay = target => new Promise((resolve, reject) => {
    target.click();
    let timeout = setTimeout(reject, 1000);
    let interval = setInterval(() => {
        if (doStuff()) {
            clearTimeout(timeout);
            clearInterval(interval);
            resolve();
        }
    }, 99);
});



String.prototype.hashCode = function() {
    let hash = 0, i, chr;
    if (this.length === 0) return hash;
    for (i = 0; i < this.length; i++) {
        chr   = this.charCodeAt(i);
        hash  = ((hash << 5) - hash) + chr;
        hash |= 0; // Convert to 32bit integer
    }
    return hash;
};

function downloadObjectAsJson(exportObj, exportName){
    let dataStr = "data:text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(exportObj));
    let downloadAnchorNode = document.createElement('a');
    downloadAnchorNode.setAttribute("href",     dataStr);
    downloadAnchorNode.setAttribute("download", exportName + ".json");
    document.body.appendChild(downloadAnchorNode); // required for firefox
    downloadAnchorNode.click();
    downloadAnchorNode.remove();
}

