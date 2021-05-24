$(document).on("click", ".delete-btn", function () {
    var company = $(this).data("company");
    var dir = $(this).data("dir");
    var id = $(this).data("id");
    $("#DeleteCompanyForm input[name=id]").val(id)
    $("#DeleteCompanyForm input[name=reportDir]").val(dir)
    $("#DeleteCompanyForm input[name=company]").val(company)
  
    $("#deletePrompt").html(" Are you sure to delete "+company+"?");
 
})
$(document).on("click", ".edit-btn", function () {
  
    var company = $(this).data("company");
    var database = $(this).data("database");
    var server = $(this).data("server");
    var removable = $(this).data("removable");
    var id = $(this).data("id");
    var dir= $(this).data("dir");
    var api = $(this).data("api");
    $("#EditCompanyForm input[name=id]").val(id)
    $("#EditCompanyForm input[name=reportDir]").val(dir)
    $("#EditCompanyForm input[name=company]").val(company)
    $("#EditCompanyForm input[name=database]").val(database)
    $("#EditCompanyForm input[name=server]").val(server)

    $("#EditCompanyForm input[name=api]").val(api)
    if (removable == "False") {
        $("#EditCompanyForm input[name=removable]").attr("checked", false);
    } else {
        $("#EditCompanyForm input[name=removable]").attr("checked", true);
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