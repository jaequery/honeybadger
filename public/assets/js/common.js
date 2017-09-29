// notifications
function notify(text) {
  setTimeout(function() {

    // create notification
    var notification = new NotificationFx({
      message : '<span class="ns-sign pull-left"><i class="material-icons">done</i></span>' + '<div class="ns-message">' + text + '</div>' + '<span class="ns-close pull-right"><i class="material-icons">close</i></span></div>',
      layout : 'bar',
      effect : 'slidetop',
      type: 'notice'
    });

    // show the notification
    notification.show();

  }, 100);
}

// shopping cart counter
function updateCartQuantity() {
  var s = $('#cart-total').text();
  var re = /\d+/;
  var qty = s.match(re);

  $('#cart-total').text(qty);

  if ($('#cart-total').text() !== "0") {
    $('#cart-total').css("display", "block");
  }
}

// update cart quantity
updateCartQuantity();

// smooth page loading
$(window).on('load', function() {
  $(".loader").fadeOut("slow");
});

// prevent right click context menu on images
// $('img').bind('contextmenu', function() {
//   return false;
// });

// tooltip
$('[data-toggle="tooltip"]').tooltip();

// sidebar account box
$('.icon-account').on('click', function(e) {

  e.preventDefault();
  
  var F = $('.account-box');
  if (F.length > 0) {
    F.addClass('open');
    return false;
  }
});

// sidebar search box
$('.icon-search').on('click', function(e) {
  e.preventDefault();
  var F = $('.search-box');
  if (F.length > 0) {
    F.addClass('open');
    return false;
  }
});

// close sidebar account box
$('.close-account-box').on('click', function() {
  $('.account-box').removeClass('open');
});

// close sidebar search box
$('.close-search-box').on('click', function() {
  $('.search-box').removeClass('open');
});

$(document).ready(function() {

  // adding the clear fix
  cols1 = $('#column-right, #column-left').length;

  if (cols1 == 2) {
    $('#content .product-layout:nth-child(2n+2)').after('<div class="clearfix visible-md visible-sm"></div>');
  } else if (cols1 == 1) {
    $('#content .product-layout:nth-child(4n+4)').after('<div class="clearfix"></div>');
  } else {
    $('#content .product-layout:nth-child(4n+4)').after('<div class="clearfix"></div>');
  }

  // highlight any found errors
  $('.text-danger').each(function() {
    var element = $(this).parent().parent();

    if (element.hasClass('form-group')) {
      element.addClass('has-error');
    }
  });

  // product list
  $('#list-view').click(function() {
    $('#content .product-layout > .clearfix').remove();

    $('#content .row > .product-layout').attr('class', 'product-layout product-list col-xs-12');

    localStorage.setItem('display', 'list');
  });

  // product grid
  $('#grid-view').click(function() {
    $('#content .product-layout > .clearfix').remove();

    // what a shame bootstrap does not take into account dynamically loaded columns
    cols = $('#column-right, #column-left').length;

    if (cols == 2) {
      $('#content .product-layout').attr('class', 'product-layout product-grid col-xs-6');
    } else if (cols == 1) {
      $('#content .product-layout').attr('class', 'product-layout product-grid col-xs-6 col-sm-3');
    } else {
      $('#content .product-layout').attr('class', 'product-layout product-grid col-xs-6 col-sm-3');
    }

     localStorage.setItem('display', 'grid');
  });

  if (localStorage.getItem('display') == 'list') {
    $('#list-view').trigger('click');
  } else {
    $('#grid-view').trigger('click');
  }

  // ripple effect
  var ink, d, x, y;
  $(".ripplelink").click(function(e) {
    if ($(this).find(".ink").length === 0) {
      $(this).prepend("<span class='ink'></span>");
    }

    ink = $(this).find(".ink");
    ink.removeClass("animate");

    if (!ink.height() && !ink.width()) {
      d = Math.max($(this).outerWidth(), $(this).outerHeight());
      ink.css({height: d, width: d});
    }

    x = e.pageX - $(this).offset().left - ink.width()/2;
    y = e.pageY - $(this).offset().top - ink.height()/2;

    ink.css({top: y+'px', left: x+'px'}).addClass("animate");
  });

});
