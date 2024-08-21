// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
import Rails from "@rails/ujs"
// import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
// Turbolinks.start()
window.$ = $;
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
    dropdownParent: $('#addUserModal') 
  });
});




// document.addEventListener('turbolinks:load', () => {
//   var dropdownElementList = [].slice.call(document.querySelectorAll('.dropdown-toggle'));
//   var dropdownList = dropdownElementList.map(function (dropdownToggleEl) {
//     return new bootstrap.Dropdown(dropdownToggleEl);
//   });
// });

document.addEventListener("DOMContentLoaded", function() {
  var selectElements = document.querySelectorAll('.js-multiple-select');
  
  selectElements.forEach(function(selectElement) {
    $(selectElement).select2({
      placeholder: selectUsersPlaceholder,
      allowClear: true,
      tags: true,
      width: 'resolve',
      language: {
        noResults: function() {
          return noUsersToShowMessage;
        }
      },
      escapeMarkup: function(markup) {
        return markup;
      }
    });

    $(selectElement).on('select2:unselect', function(e) {
      var unselected_id = e.params.data.id;
      $(this).find('option[value="'+unselected_id+'"]').remove();
    });
  });
});

