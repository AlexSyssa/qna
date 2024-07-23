javascript
console.log("JavaScript is working!");
import "jquery";
import Rails from "@rails/ujs";
Rails.start();
import "@hotwired/turbo-rails";
import "controllers";
import React from 'react';
import ReactDOM from 'react-dom';
import '../utilities/answers.js'
import '../utilities/questions.js'

// Обработчик событий для загрузки страницы
document.addEventListener('turbo:load', function () {
    $('.answers').on('click', '.edit-answer-link', function (e) {
        e.preventDefault();
        $(this).hide();
        var answerId = $(this).data('answer-id');
        console.log(answerId);
        $('form#edit-answer-' + answerId).removeClass('hidden');
    });
});