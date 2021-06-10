$(document).on("click", ".delete-btn", function () {
    var name = $(this).data("name");

    var id = $(this).data("id");
    $("#DeleteForm input[name=id]").val(id)
  
 
    $("#deletePrompt").html(" Are you sure to delete the repository <br>[" + name + "]? ");

 
})
$(document).on("click", ".edit-btn", function () {
  
    var name = $(this).data("name");
    var url = $(this).data("url");
    var description = $(this).data("description");
    var private = $(this).data("private");
    var id = $(this).data("id");

    $("#EditForm input[name=id]").val(id)
    $("#EditForm input[name=name]").val(name)
    $("#EditForm input[name=url]").val(url)
    $("#EditForm textarea[name=description]").val(description)
    if (private == "False") {
        $("#EditForm input[name=private]").prop("checked", false);
    } else {
        $("#EditForm input[name=private]").prop("checked", true);
    }

})


