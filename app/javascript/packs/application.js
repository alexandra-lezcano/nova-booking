
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
import $ from "jquery";

require("modernizr/modernizr.custom.js");

// require("@rails/ujs").start()
// //require("turbolinks").start()
// require("@rails/activestorage").start()
// require("channels")
//import '../stylesheets/application'
//--- Bootstrap
//import 'bootstrap';

import appInit from './angle/app.init.js';
document.addEventListener('DOMContentLoaded', appInit);

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

// for image preview in_form.html.erb
$(function() {
    const HEIGHT = 150;
    const WIDTH = 150;
    $('#pictureInput').on('change', function(event) {
        let files = event.target.files;
        let image = files[0];
        let reader = new FileReader();
        reader.onload = function(file) {
            let img = new Image();
            img.src = file.target.result;
            img.classList.add("img-thumbnail"); //alt="rss fit" height="150" width="150"
            img.setAttribute('alt', 'rss fit');
            img.setAttribute('height', HEIGHT);
            img.setAttribute('width', WIDTH);
            $('#target').append(img);
        };
        reader.readAsDataURL(image);
    });
});

$(document).on('click', '.remove_fields', function (e) {
    //elimina el partial que tiene estos enlaces
    $(this).closest('fieldset').detach();
    e.preventDefault()
});

$(document).on('click', '.add_fields', function (e) {
    //console.log("add fields link clicked")
    let time = new Date().getTime()
    let regexp = new RegExp($(this).data('id'), 'g')
    //console.log()
    $(this).before($(this).data('fields').replace(regexp, time))
    e.preventDefault()
});