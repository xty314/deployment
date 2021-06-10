$(document).on("change", "#passwordChange", function (e) {
    if (this.checked) {
        $("#passwordRow").show();
        $("#EditUserForm input[name='password']").attr("disabled", false);
    } else {
        $("#passwordRow").hide();
        $("#EditUserForm input[name='password']").attr("disabled", true);
    }
})
$(document).on("click", ".edit-btn", function (e) {

    var id = $(this).data("id");
    var email = $(this).data("email");
    var name = $(this).data("name");
    $("#EditUserForm input[name=id]").val(id)
    $("#EditUserForm input[name=email]").val(email)
    $("#EditUserForm input[name=name]").val(name)

})
$(document).on("click", ".delete-btn", function (e) {

    var id = $(this).data("id");
    $("#DeleteUserForm input[name=id]").val(id)
    $("#deletePrompt").html("Are you sure to delete " + $(this).data("email"))

})
