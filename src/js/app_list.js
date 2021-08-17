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
    var repo = $(this).data("repo");

    if (repo > 0) {
        $("#deleteCheck").attr("disabled", false);
    } else {
        $("#deleteCheck").attr("disabled", true);
    }
   
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
$(document).on("click", ".copy-btn", function (e) {
    var apiContent = $(this).prev().html();

    var ele = document.createElement("input"); //创建一个input标签
    ele.setAttribute("value", apiContent); // 设置改input的value值
    document.body.appendChild(ele); // 将input添加到body
    ele.select();  // 获取input的文本内容
    document.execCommand("copy"); // 执行copy指令
    document.body.removeChild(ele); // 删除input标签
    var Toast = Swal.mixin({
        toast: true,
        position: 'top-end',
        showConfirmButton: false,
        timer: 3000
    });
    Toast.fire({
        icon: "success",
        title: apiContent + " has already been copied."
    })

})
$(document).on("click", ".pull-btn", function (e) {
    var id = $(this).data("id");
    $("#PullForm input[name=id]").val(id)
})
$(document).on("click", ".restart-btn", function (e) {
    var id = $(this).data("id");
    $("#RestartForm input[name=id]").val(id);
})