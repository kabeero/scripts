// ==UserScript==
// @name         Highlight JS
// @namespace    http://tampermonkey.net/
// @version      2024-07-18
// @description  try to take over the world!
// @author       M K Gharzai
// @match        https://website/consoleText
// @icon         https://www.google.com/s2/favicons?sz=256&domain=meta.com
// @grant        none
// ==/UserScript==

(() => {
  var colorScheme = "tokyo-night-dark";
  var link = document.createElement("link");
  link.setAttribute("rel", "stylesheet");
  link.setAttribute("type", "text/css");
  link.setAttribute(
    "href",
    "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.10.0/styles/" +
      colorScheme +
      ".min.css",
  );
  document.getElementsByTagName("head")[0].appendChild(link);
  var script = document.createElement("script");
  script.type = "text/javascript";
  script.src =
    "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.10.0/highlight.min.js";

  document.head.appendChild(script);
  script.addEventListener("load", function () {
    var pres = document.querySelectorAll("pre");
    for (var i = 0; i < pres.length; ++i) {
      if (!pres[i].querySelector("code")) {
        window.hljs.highlightElement(pres[i]);
      } else {
        window.hljs.highlightElement(pres[i].querySelectorAll("code")[0]);
      }
    }
    if (pres.length == 0) {
      console.log("applying to :root");
      window.hljs.highlightElement(document.querySelector(":root"));
    }
  });
})();
