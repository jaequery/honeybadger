// Put your application scripts here


var app = {
  methods: {
    alert: function(title, text, type){
      swal({   title: title,   text: text,   type: 'Notice',   confirmButtonText: "Ok" });
    }
  }
};
