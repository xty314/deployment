
$(document).on("click", ".script-btn", function (e) {

    var id = $(this).data("id");
    $("#ScriptForm input[name=id]").val(id)
    console.log(id);
    $.ajax({
        type: "get",
        url: "handler/ScriptDuallist.ashx?dbid="+id,
        success: function (res) {
            $('#scriptDuallist').bootstrapDualListbox("destroy");
            $('#scriptDuallist').remove();
            $("#scriptLabel").after(res);
            $('#scriptDuallist').bootstrapDualListbox({
                nonSelectedListLabel: 'Unexecuted Scripts',
                selectedListLabel: 'Executed Scripts',
                selectorMinimalHeight: 300,
                filterTextClear: 'Show All',
                filterPlaceHolder: 'Filter',
                moveSelectedLabel: "Add",
                moveAllLabel: 'Select All',
                removeSelectedLabel: "Remove",
                removeAllLabel: 'Remove All',
                infoText: ' {0} scripts ',
                infoTextFiltered: 'get {0} scripts ,total {1} scripts',
                infoTextEmpty: 'No scripts ',
            });
       

    
        }

    })
})