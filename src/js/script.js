$(function () {
    bsCustomFileInput.init();
});
$(document).on("change", "#scriptFile", function (e) {
    if (!$("#scriptName").val()) {
        var name = this.value.split("\\");
        $("#scriptName").val(name[name.length-1])
    }
})