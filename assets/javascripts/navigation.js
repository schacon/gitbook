$(document).keydown(function(ev) {
  if (ev.keyCode == 37) {
    if ($("div.nav a").size() === 2) {
      window.location = $(".nav:first-child a").attr('href');
      return false;
    }
    else if ($("div.nav a").size() === 1 && $("div.nav a:first").text().toLowerCase().indexOf("prev") !== -1 ) {
      window.location = $("div.nav a:first").attr('href');
      return false;
    }
  }
  else if (ev.keyCode == 39) {  
    if ($("div.nav a").size() === 2) {
      window.location = $("div.nav a:last").attr('href');
      return false;
    }
    else if ($("div.nav a").size() === 1 && $("div.nav a:first").text().toLowerCase().indexOf("next") !== -1) {
      window.location = $("div.nav a:first").attr('href');
      return false;
    }
  }
});
