// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.


import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()


import $ from 'jquery';
import 'select2';
import "chartkick/chart.js"



document.addEventListener('shown.bs.modal', function () {
  $('.js-multiple-select').select2({
    placeholder: 'Select users',
    allowClear: true,
    tags: true,
    width: 'resolve',
    dropdownParent: $('#addUserModal') // Ensures the dropdown is correctly placed within the modal
  });
});


document.addEventListener("turbolinks:load", () => {
    var dropdownElementList = [].slice.call(document.querySelectorAll('.dropdown-toggle'));
    var dropdownList = dropdownElementList.map(function (dropdownToggleEl) {
    return new bootstrap.Dropdown(dropdownToggleEl)
    })
});
