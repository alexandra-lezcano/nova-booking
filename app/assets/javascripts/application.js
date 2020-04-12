// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
//= require rails-ujs
//--- Angle
//= require angle/modules/common/wrapper.js
//= require angle/app.init
//= require_tree ./angle/modules
//= require_tree ./angle/custom

//= require jquery.validate
//= require jquery.validate.additional-methods

////= require jquery3
////= require bootstrap
//= require turbolinks

//= require filterrific/filterrific-jquery
//= require bootstrap-datepicker
//= require bootstrap-datepicker/core
//= require bootstrap-datepicker/locales/bootstrap-datepicker.es
//= require bootstrap-slider

//-- Selectize
//= require selectize


//= require croppie/croppie
//= require bootbox/bootbox.all
// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

// for image preview for file fields
// div where image will be added should have id="target"

const HEIGHT = 150;
const WIDTH = 150;
$(document).on('change', '#pictureInput', function (event) {
    let files = event.target.files;

    Array.from(files).forEach(file => {
        let reader = new FileReader();
        reader.onload = function (file) {
            let img = new Image();
            img.src = file.target.result;
            img.classList.add("img-thumbnail");
            img.setAttribute('alt', 'rss fit');
            img.setAttribute('height', HEIGHT);
            img.setAttribute('width', WIDTH);
            $('#target').append(img);
            $('img').css("display", "inline-block")
        };
        reader.readAsDataURL(file);
    });

    if (Array.from(files).length > 0) {
        $('#target').empty();
    }
});
let canvas,
    $result;
$(document).on('change', '#pictureInput1', function (event) {
    canvas  = $("#canvas");
    canvas.croppie('destroy');
    $result = $('#target');
    let files = event.target.files;
    Array.from(files).forEach(file => {
        let reader = new FileReader();
        reader.onload = function (file) {
            let img = new Image();
            img.src = file.target.result;
            img.setAttribute('alt', 'Picture');
            img.onload = function() {
                let crop = canvas.croppie({
                    viewport: {
                        width: WIDTH,
                        height: HEIGHT
                    },
                    boundary: {
                        width: 300,
                        height: 300
                    },
                    enableOrientation: true
                });
                $("#crop_modal").modal('show');
                canvas.croppie('bind',{
                    url: img.src,
                    orientation: 1
                }).then(function(){
                    $('.cr-slider').attr({'min':0.1000, 'max':1.5000});
                });
                $('#result-input').click(function() {
                    // Get a string base 64 data url
                    canvas.croppie('result', {
                        type: 'base64',
                        size: 'viewport'
                    }).then(function (resp) {
                        $result.html($('<img>').attr('src', resp));
                        $("#image").attr('value',resp);
                    });
                    $("#crop_modal").modal('hide');
                });
            };
        };

        reader.readAsDataURL(file);
    });
});
// ****************************************************************************** //

// Fuente: https://gist.github.com/gordonbrander/2230317

var ID = function () {
  // Math.random should be unique because of its seeding algorithm.
  // Convert it to base 36 (numbers + letters), and grab the first 9 characters
  // after the decimal.
  return '_' + Math.random().toString(36).substr(2, 9);
};

// ****************************************************************************** //

$(document).on('change', '.picture .pictureInput2', function(event) {
  let files = event.target.files;

  $(this).closest('div').next().attr('id', ID());
  let targetId = $(this).closest('div').next().attr('id');

  Array.from(files).forEach(file => {
    let reader = new FileReader();
    reader.onload = function (file) {
        let img = new Image();
        img.src = file.target.result;
        img.classList.add("img-thumbnail");
        img.setAttribute('alt', 'rss fit');
        img.setAttribute('height', HEIGHT);
        img.setAttribute('width', WIDTH);
        $('#'+targetId).append(img);
        $('img').css("display", "inline-block")
    };
    reader.readAsDataURL(file);
  });

  if (Array.from(files).length > 0) {
      $('#'+targetId).empty();
  }

});

$(document).on('click', '.remove_fields', function (e) {
    //elimina el partial que tiene estos enlaces
    let fieldParent = $(this).closest('fieldset'),
        deleteField = fieldParent ? fieldParent.find('input[type="hidden"]') : null;
    e.preventDefault();
    bootbox.confirm({
        title: "Eliminar Habitación?",
        message: "Estas seguro de querer eliminarlo",
        locale: 'es',
        callback: function (result) {
            if (result) {
                if (deleteField) {
                    deleteField.val('1');
                    $("input").attr("required", false);
                    fieldParent.css({display: "none"});
                }
            }
        }
    });
});

$(document).on('click', '.remove_fields2', function (e) {
    //elimina el partial que tiene estos enlaces
    $(this).closest('fieldset').detach();
    e.preventDefault()
});

$(document).on('click', '.show_fields', function (e) {
    $(this).siblings('.ocultar').fadeIn(400)
    $(this).siblings('.description').text('')
    //console.log($(this).siblings('.ocultar').find('.room_name').val())

});

$(document).on('click', '.hide_fields', function (e) {
    $(this).siblings('.ocultar').fadeOut(400)
    let description = $(this).siblings('.ocultar').find('.room_name').val()
    $(this).siblings('.description').html("<h3><strong>" + description + "</strong></h3>")
    //console.log($(this).siblings('.ocultar').find('.room_name').val())
});


$(document).on('click', '.add_fields', function (e) {
    $('.ocultar').fadeOut(400)
    let description = $('.room_name').last().val()
    $('.description').last().html("<h3><strong>" + description + "</strong></h3>")

    let time = new Date().getTime()
    let regexp = new RegExp($(this).data('id'), 'g')
    //console.log()
    $(this).before($(this).data('fields').replace(regexp, time))
    e.preventDefault()
});

$(document).on('keyup', '.validame', function (e){
    let num = $(e.target).val();
    num = num.replace(/[\D\s\._\-]+/g, "");
    num = num?parseInt(num, 10):0;
    $(e.target).val(function () {
        let aux = (num === 0) ? "" : num;
        return aux;
    });
});

let message = "Debe ser un número positivo"