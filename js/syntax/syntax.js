/*
 * https://gist.github.com/EvanLovely/246049c33e0f14aad2b7
 * https://caiorss.github.io/bookmarklet-maker/
 * https://github.com/highlightjs/highlight.js/tree/main/src/styles
 * https://highlightjs.org/demo
 */

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
script.setAttribute("type", "text/javascript");
script.setAttribute(
  "src",
  "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.10.0/highlight.min.js",
);
document.getElementsByTagName("head")[0].appendChild(script);
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
