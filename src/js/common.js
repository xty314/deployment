

    $(function () {
        $('[data-toggle="tooltip"]').tooltip()
    })

     

function GetHtml($dom) {
    return $('<div>').append($dom.clone()).remove().html()
}
