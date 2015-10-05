window.jazzy = {'docset': false}
if (typeof window.dash != 'undefined') {
  document.documentElement.className += ' dash'
  window.jazzy.docset = true
}
if (navigator.userAgent.match(/xcode/i)) {
  document.documentElement.className += ' xcode'
  window.jazzy.docset = true
}

$.expr[':'].textEquals = $.expr.createPseudo(function(arg) {
    return function( elem ) {
        return $(elem).text().match("^" + arg + "$");
    };
});

// On doc load, toggle the URL hash discussion if present and remove unnecessary symbols.
$(document).ready(function() {
  if (!window.jazzy.docset) {
    var linkToHash = $('a[href="' + window.location.hash +'"]');
    linkToHash.trigger("click");
  }
  $('a[href*="Extensions.html#"]').remove();
  $( ".nav-group-task:contains('=')" ).remove();
  $( ".nav-group-task:contains('+')" ).remove();
  $( ".nav-group-task:contains('-')" ).remove();
  $( ".nav-group-task:contains('*')" ).remove();
  $( ".nav-group-task:contains('/')" ).remove();
  $( ".nav-group-task:contains('inverse')" ).remove();
});

// On token click, toggle its discussion and animate token.marginLeft
$(".token").click(function() {
  if (window.jazzy.docset) {
    return;
  }
  var link = $(this);
  var animationDuration = 300;
  var tokenOffset = "15px";
  var original = link.css('marginLeft') == tokenOffset;
  link.animate({'margin-left':original ? "0px" : tokenOffset}, animationDuration);
  $content = link.parent().parent().next();
  $content.slideToggle(animationDuration);
});