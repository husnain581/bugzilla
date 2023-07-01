function update_dropdown(){
  value = $('#type_dropdown').val()
  $.ajax({
  url: "/update_dropdown",
  type: "POST",
  data: {type: value},
  success: function(response){
    var data = response.dropdownfields;
    var obj = document.getElementById('status_field').options[3];
    obj.text = data[0][0]
    obj.value = data[0][1];
  },
  error: function(data) {
    console.log("error")
  }
  })
}
