
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

// for image preview for file fields
// div where image will be added should have id="target"
$(function() {
    const HEIGHT = 150;
    const WIDTH = 150;
    $('#pictureInput').on('change', function(event) {
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
    });
});