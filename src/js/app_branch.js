$(document).on("click", ".edit-btn", function (e) {

    var id = $(this).data("id");

    var name = $(this).data("name");
    var address1 = $(this).data("address1");
    var address2 = $(this).data("address2");
    var address3 = $(this).data("address3");
    var auth_code = $(this).data("auth_code");
    $("#EditBranchForm input[name=id]").val(id)
  
    $("#EditBranchForm input[name=name]").val(name)
    $("#EditBranchForm input[name=address1]").val(address1)
    $("#EditBranchForm input[name=address2]").val(address2)
    $("#EditBranchForm input[name=address3]").val(address3)
    $("#EditBranchForm input[name=auth_code]").val(auth_code)

})
$(document).on("click", ".delete-btn", function (e) {

    var id = $(this).data("id");
    $("#DeleteBranchForm input[name=id]").val(id)
    $("#deletePrompt").html("Are you sure to delete " + $(this).data("name"))

})