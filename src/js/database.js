$(document).on("click", ".delete-btn", function () {
    var name = $(this).data("name");
    var origin = $(this).data("origin");
    var id = $(this).data("id");
    $("#DeleteForm input[name=id]").val(id)
  
 
   
    if (origin == 0) {
        $("#deletePrompt").html(" Are you sure to delete the record of [" + name + "]? <br> The database is not created by this app, so you can not delete the database.");
        $("#deleteDbCheck").prop("checked", false);
        $("#backupCheck").prop("checked", false);
        $("#deleteDbCheck").prop("disabled", true);
        $("#backupCheck").prop("disabled", true);
    } else {
        $("#deletePrompt").html(" Are you sure to delete [" + name + "]? ");
        $("#deleteDbCheck").prop("disabled", false);
        $("#backupCheck").prop("disabled", false);
    }
 
})
$(document).on("click", ".edit-btn", function () {
  
    var name = $(this).data("name");
    var database = $(this).data("database");
    var server = $(this).data("server");
    var removable = $(this).data("removable");
    var id = $(this).data("id");

    $("#EditForm input[name=id]").val(id)
    $("#EditForm input[name=name]").val(name)
    $("#EditForm input[name=database]").val(database)
    $("#EditForm input[name=server]").val(server)
    if (removable == "False") {
        $("#EditForm input[name=removable]").prop("checked", false);
    } else {
        $("#EditForm input[name=removable]").prop("checked", true);
    }

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
        title: apiContent +" has already been copied."
    })

})