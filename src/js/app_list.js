//$(document).on("change", "#passwordChange", function (e) {
//    if (this.checked) {
//        $("#passwordRow").show();
//        $("#EditUserForm input[name='password']").attr("disabled", false);
//    } else {
//        $("#passwordRow").hide();
//        $("#EditUserForm input[name='password']").attr("disabled", true);
//    }
//})
$(document).on("click", ".edit-btn", function (e) {

    var name = $(this).data("name");
    var db_id = $(this).data("db");
    var description = $(this).data("description");
    var removable = $(this).data("removable");
    var id = $(this).data("id");

    $("#EditForm input[name=id]").val(id);
    $("#EditForm textarea[name=description]").val(description);
    $("#EditForm input[name=name]").val(name);
    $("#EditForm select[name=db]").val(db_id);


    if (removable == "False") {
        $("#EditForm input[name=removable]").attr("checked", false);
    } else {
        $("#EditForm input[name=removable]").attr("checked", true);
    }

})
$(document).on("click", ".delete-btn", function (e) {

    var id = $(this).data("id");
    $("#DeleteForm input[name=id]").val(id)
    $("#deletePrompt").html("Are you sure to delete [" + $(this).data("name")+"]")
    $("#deleteFileLocation").html(" [" + $(this).data("location") + "]")
})

$(document).on("click", ".unbind-btn", function (e) {
    var id = $(this).data("id");
    $("#UnbindForm input[name=id]").val(id)
})
$(document).on("click", ".deploy-btn", function (e) {
    var id = $(this).data("id");
    $("#DeployForm input[name=id]").val(id)
})
