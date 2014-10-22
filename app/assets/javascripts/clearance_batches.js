
/*  Formats number into a dollar value 
Solution Credit: http://stackoverflow.com/questions/149055/how-can-i-format-numbers-as-money-in-javascript
*/
function formatDollar(num) {
    var p = num.toFixed(2).split(".");
    return [p[0].split("").reverse().reduce(function(acc, num, i) {
        return num + (i && !(i % 3) ? "," : "") + acc;
    }, "."), p[1]].join("");
}

/* When a user clicks the show all items link, the first time, we make an ajax call to load the data
from the server.  Any other time, we just show or hide the data.
*/
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
      // Not working but leaving for future reference.  No alternate class to remove.
      $('tr').removeClass('alternate');
      $('tr:not(.hide):odd').addClass('alternate');
    }
  } else {
    $.ajax({
      type: "GET",
      url: path,
      data: {batch_id: batch_id},
      success: function(data, textStatus) {
        if (data.items.length > 0) {
          results = "<table class='table'>";
  
          $.each(data.items, function (index, value) {
            item = value.item
            style = value.style
            results += "<tr><td>" + item.id + "</td><td>" + style.type + "</td><td>" + style.name + "(" + item.size + ") </td><td>Sold At: $" + formatDollar(Number(item.price_sold)) + "</td></tr>"
          });
          results += "</table>"
          $(link).closest("tr").after("<tr id='items-" + item.clearance_batch_id +"'><td colspan='3'>" + results + "</td></tr>");
          link.innerHTML = "Hide Items";
          
        } // data.items.length > 0 
      } // success handler
    }); //ajax call
    } //end batch_items.length > 0
} // end showAllEvent function


/* Move the entry into the scanned_items list  
*/
function addScannedItem(event) {
  event.stopPropagation();
  event.preventDefault();
  current_list = $('#scanned_items').val();
  if (current_list.length > 0) {
    current_list += "," 
  }
  current_list += $('#scanned_item').val();
  
  $('#scanned_items').val( current_list);
  $('#scanned_item').val('');  
}
