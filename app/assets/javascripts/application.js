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
  if ($("#stocklist").length > 0) {
//  setTimeout(updateStockValues, 5000);
    setTimeout(updateStockView, 10000);
  }
});

// notes from Iain at carbon 5
// console.log() is very useful
//   don't use console.log(obj + "text") if obj is object, not string
function updateStockView() {
  $.getJSON("/getservice", function(data) {
//  alert("aack!");
//  $.each(data, function(obj) {
//    alert(obj.value);
//    alert("aaoooga!");
//  });
    console.log(data);
//  $(data).each(function(obj) {
    $.each(data, function(i, obj) {
      var td, tr;
      td = $("#stocklist td.companysymbol:contains('" + obj.companysymbol + "')");
      console.log(
        "#stocklist td.companysymbol:contains('" + obj.companysymbol + "')"
      );
      tr = td.parent();
      console.log("obj:");
      console.log(obj);
      console.log("td:");
      console.log(td);
      console.log("tr:");
      console.log(tr);
//    $(obj).each(function(key, val) {
// could limit to specific keys, e.g. value delta
      $.each(obj, function(key, val) {
//      $("#stocklist td.companysymbol:eq('" + val + );
        console.log("key val:");
        console.log([key, val]);
        $("td." + key, tr).text(val);
        console.log( $("td." + key, tr) );
//      $(val).each(function(k, v) {
//        console.log("k v:");
//        console.log([k, v]);
//      });
      });
    });
  });
  setTimeout(updateStockView, 10000);
}

