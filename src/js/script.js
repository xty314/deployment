$(function () {
    bsCustomFileInput.init();
    
        // CodeMirror
    $('.codeMirror').each(function (index, elem) {
        CodeMirror.fromTextArea(elem, {
            mode: "sql",
            theme: "monokai"
        });
    });


});
$(document).on("change", "#scriptFile", function (e) {
    if (!$("#scriptName").val()) {
        var name = this.value.split("\\");
        name = name[name.length - 1]
        
        $("#scriptName").val(name.split(".")[0])
    }
})
$(document).on("click", ".deleteBtn", function (e) {
    var id = $(this).data("id");
    $("#DeleteForm").find("input[name=id]").val(id);
    console.log(id)
})
$(document).on("click", ".editBtn", function (e) {
    var id = $(this).data("id");
    var name = $(this).data("name");
    var description = $(this).data("description");
    var location = $(this).data("location");
    $("#EditForm").find("input[name=id]").val(id);
    $("#EditForm").find("input[name=name]").val(name);
    $("#EditForm").find("textarea[name=description]").val(description);
    $("#location").html(location);

})