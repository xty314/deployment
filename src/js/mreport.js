$(document).on("click", ".delete-btn", function () {
    var name = $(this).data("name");

    var id = $(this).data("id");
    $("#DeleteForm input[name=id]").val(id)
  
 
    $("#deletePrompt").html(" Are you sure to delete the mreport <br>[" + name + "]? ");

 
})
$(document).on("click", ".edit-btn", function () {
  
    var name = $(this).data("name");

    var description = $(this).data("description");
    var id = $(this).data("id");
    var app_id = $(this).data("app");
    console.log(app_id)
    $("#EditForm input[name=id]").val(id)
    $("#EditForm select[name=app]").val(app_id);
    $("#EditForm input[name=name]").val(name)
    $("#EditForm textarea[name=description]").val(description)


})


