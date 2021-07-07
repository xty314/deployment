

$(function () {
    $('[data-toggle="tooltip"]').tooltip()
})
$(document).on("click", ".once-click-btn", function () {
    this.disabled = true;
})
     

function GetHtml($dom) {
    return $('<div>').append($dom.clone()).remove().html()
}
