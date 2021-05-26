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
        $("#scriptName").val(name[name.length-1])
    }
})