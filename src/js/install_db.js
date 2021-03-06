//$(document).on("click", ".delete-btn", function () {
//    var name = $(this).data("name");
//    var origin = $(this).data("origin");
//    var id = $(this).data("id");
//    $("#DeleteForm input[name=id]").val(id)
  
 
   
//    if (origin == 0) {
//        $("#deletePrompt").html(" Are you sure to delete the record of [" + name + "]? <br> The database is not created by this app, so you can not delete the database.");
//        $("#deleteDbCheck").prop("checked", false);
//        $("#backupCheck").prop("checked", false);
//        $("#deleteDbCheck").prop("disabled", true);
//        $("#backupCheck").prop("disabled", true);
//    } else {
//        $("#deletePrompt").html(" Are you sure to delete [" + name + "]? ");
//        $("#deleteDbCheck").prop("disabled", false);
//        $("#backupCheck").prop("disabled", false);
//    }
 
//})
$(document).on("click", ".edit-btn", function (e) {
  
    var name = $(this).data("name");
    var database = $(this).data("database");
    var server = $(this).data("server");
    var location = $(this).data("location");
    var id = $(this).data("id");
    var description = $(this).data("description");
    console.log(description)
    $("#EditForm input[name=id]").val(id)
    $("#EditForm input[name=name]").val(name)
    $("#EditForm input[name=location]").val(location)
    $("#EditForm input[name=database]").val(database)
    $("#EditForm input[name=server]").val(server)

    $("#EditForm textarea[name=description]").val(description);


})
$(document).on("click", ".script-btn", function (e) {
    var id = $(this).data("id");
    $("#ScriptForm input[name=id]").val(id);
    $.ajax({
        type: "get",
        url: "handler/ScriptDuallist.ashx?install=" + id,
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
                infoTextEmpty: 'No scripts '
            });
        }
    })
})


