// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(function() {
//  if ($("#stop_stocklist").length > 0) {
  if ($("#stocklist").length > 0) {
    setTimeout(updateStockValues, 5000);
    setTimeout(updateStockView, 10000);  // test, not for real use
  }
});

function updateStockValues() {  // test function to update stocks
//  console.log("updateStockValues()");
  $.getJSON("/getservice");
//  $.getJSON("/getservice", function(data) {
//  });
  setTimeout(updateStockValues, 20000);
}

// notes from Iain at carbon 5
// don't use console.log(obj + "text") if obj is object, not string
function updateStockView() {
//  $.getJSON("/getservice", function(data) {
  $.getJSON("/stocks", function(data) {  // goes to stocks#index
//  console.log(data);
    $.each(data, function(i, obj) {
      var tr;

//    tr = $("#stocklist td:contains('" + obj.companysymbol + "')").parent();
      tr = $("#stocklist td.companysymbol:contains('" + obj.companysymbol + "')").parent();
      console.log(
        "#stocklist td.companysymbol:contains('" + obj.companysymbol + "').parent()"
      );

//    console.log("obj:");
      console.log(obj);
      console.log([obj.companysymbol, obj.value, obj.delta]);
//    console.log("tr:");
//    console.log(tr);

//    td.next().text(obj.value);  // works, but depends on order
//    td.next().next().text(obj.delta);

      tr.children(".value").text(obj.value); // works, independent of order
//    tr.children(".delta").text(obj.delta);
      if (new Number(obj.delta) < 0) {
        console.log("delta is negative");
        tr.children(".delta").text(obj.delta).css("color","red");
      } else {
        console.log("delta is positive");
        tr.children(".delta").text(obj.delta).css("color","green");
      }

//    console.log("key val selector:");
//    $.each(obj, function(key, val) {
//      console.log([key, val]);
// see jQuery('element') link to jQuery function, jQuery(selector [,context])
//      $("td." + key, tr).text(val);
//    });
    });
  });
  setTimeout(updateStockView, 10000);
}

