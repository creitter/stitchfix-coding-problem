// Script to be moved to external js file.

function formatDollar(num) {
    var p = num.toFixed(2).split(".");
    return [p[0].split("").reverse().reduce(function(acc, num, i) {
        return num + (i && !(i % 3) ? "," : "") + acc;
    }, "."), p[1]].join("");
}

function showAllEvent(event, link, path) {
  event.stopPropagation();
  event.preventDefault();
  
  batch_id = link.attributes['data-batch-id'].value;
  batch_items = $("#items-" + batch_id);

  if (batch_items.length > 0) {
    $(batch_items).toggle();
    if ($(batch_items).is(":visible")) {
      link.innerHTML = "Hide Items";
    } else {
      link.innerHTML = "Show Items";
    }
  } else {
    $.ajax({
      type: "GET",
      url: path,
      data: {batch_id: batch_id},
      success: function(data, textStatus) {
        if (data.items.length > 0) {
          results = "";
  
          $.each(data.items, function (index, value) {
            item = value.item
            style = value.style
            results += "<div style='padding:5px 0 0 15px;'>" + item.id + ": " + style.type + " - " + style.name + "(" + item.size + ") Sold At: $" + formatDollar(Number(item.price_sold)) + "</div>"
          });
  
          $(link).closest("tr").parent().append("<tr id='items-" + item.clearance_batch_id +"'><td colspan='3'>" + results + "</td></tr>");
          link.innerHTML = "Hide Items";
          
        } // data.items.length > 0 
      } // success handler
    }); //ajax call
    } //end batch_items.length > 0
} // end showAllEvent function

