
// update the page depending on the data
function apply_data(data) {
  // populate the page with the data now
  var newData = jQuery.parseJSON(data);

  // console.log(data);
  /* note, we're using the classes as follows:
    - "label-success" - green, can Buy
    - "label-danger"  - red, can Sell
    - "disabled"      - grey, don't own, can't afford
  */
  $('#bank_balance').text(newData.cash_reserve);
  $('#message').html(newData.message);
  $.each(newData.artworks, function(key, value) {
    $("#price_" + key).text(value.price);
    if (value.own) {
      $("#" + key).text('Sell');
      $("#" + key).removeClass("disabled");
      $("#" + key).removeClass("label-success");
      $("#" + key).addClass("label-danger");
    }
    else if (newData.cash_reserve >= value.price) {
      $("#" + key).text('Buy');
      $("#" + key).removeClass("disabled");
      $("#" + key).removeClass("label-danger");
      $("#" + key).addClass("label-success");
    }
    else {
      $("#" + key).text('Too ritzy for me!');
      $("#" + key).removeClass("label-danger");
      $("#" + key).removeClass("label-success");
      $("#" + key).addClass("disabled");
    }
  });

}

// === ISOTOPE ===
$(function(){
  $('#container').isotope({
    // options
    itemSelector : '.item',
    layoutMode   : 'masonry',
    masonry: {
      columnWidth: 220
    },
    animationEngine : 'best-available',
    animationOptions: {duration: 750, easing: 'linear', queue: false}
  });
});
// === END ===

// this is called on page load
$(document).ready(function(){

  // assign the toggle ownership button to each image wrapped in a 'transaction' class
  $(".transaction").click(function(){
    if ($(this).hasClass('disabled')) {
      return;
    }
    // on click, call /toggle-ownership/<id>
    $.get("/toggle-ownership/"+ $(this).attr("id"), function (data, status) {
      if (status != 'success') {
        alert("I wonder if the server's down...");
        return;
      }
      // on response, update the page
      apply_data(data);
    });
  });

  // finally, populate everthing on page load
  $.get("/retrieve-data", function(data, status) {
    if (status != 'success') {
      alert("I wonder if the server's down...");
      return;
    }
    apply_data(data);
  });

  $('#container').isotope('reLayout');
});

