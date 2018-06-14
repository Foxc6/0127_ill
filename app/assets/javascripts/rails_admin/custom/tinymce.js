function tinymce_load(){
  tinymce.init({
    selector: "textarea",
    plugins: [
     "advlist autolink lists link image charmap print preview anchor",
     "searchreplace visualblocks code fullscreen autoresize",
     "insertdatetime media table contextmenu paste"
    ],
    menu : "core",
    toolbar: "bold italic bullist numlist outdent indent | link"
  });
}
$(window).load(tinymce_load());