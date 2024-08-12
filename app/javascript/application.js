javascript
// app/javascript/application.js
console.log("JavaScript is working!");
import "@hotwired/turbo-rails";
import jquery from "jquery";
window.jQuery = jquery;
window.$ = jquery;
import "@nathanvda/cocoon";
import Rails from "@rails/ujs";
Rails.start();
// import "controllers";
import React from 'react';
import ReactDOM from 'react-dom';
import 'utilities/answers';
import 'utilities/questions';