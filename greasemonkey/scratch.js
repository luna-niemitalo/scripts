// ==UserScript==
// @name     Unnamed Script 816693
// @version  1
// @grant    none
// @include https://www.patreon.com/*
// @require https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js

// ==/UserScript==

let images = new Set();
let paths = new Set();
let done = [];


$("body").bind("DOMSubtreeModified", function() {
    let selector = $( "img[class*='1h4huqp']" );
    selector.css('border', '5px solid red');
    for (let i = 0; i < selector.length; i++){
        images.add(selector[i])
    }

});

async function clickImages(){
    if (paths.size === images.size) return;
    for (let value of images){
        let hash = value.src.hashCode();
        if (done.includes(hash)) continue;
        done.push(hash);
        await delay(value).catch(() => {delete done[hash]});
    }
}

setInterval(() => {clickImages()}, 5000);
// A $( document ).ready() block.
$( document ).ready(function() {
    console.log( "ready!" );
    $(document).keypress(function(e) {
        if(e.which === 13) {
            console.log(images);
            console.log(paths);
        }
    });
});

function doStuff(){
    let hoverBoxDiv = $( "div[class*='1z0k0vk']" );
    if (hoverBoxDiv.length !== 0) {
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


