# Pin npm packages by running ./bin/importmap

pin "application"
pin "react" # https://ga.jspm.io/npm:react@17.0.2/index.js
pin "object-assign" # https://ga.jspm.io/npm:object-assign@4.1.1/index.js
pin "react-dom" # @18.3.1
pin "scheduler" # @0.23.2
pin "@rails/actioncable", to: "actioncable.esm.js"
pin "@rails/activestorage", to: "activestorage.esm.js"
pin "@rails/actiontext", to: "actiontext.esm.js"

pin "@github/hotkey", to: "@github--hotkey.js" # file lives in vendor/javascript/@github--hotkey.js
pin "md5", preload: false # file lives in vendor/javascript/md5.js

pin "trix"
# NOTE: pin jquery to jsdelivr instead of jspm
pin "jquery", to: "https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.js"

pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true

# my_engine/config/importmap.rb

# pin_all_from File.expand_path("../app/assets/javascripts", __dir__)

pin_all_from 'app/javascript/src', under: 'src', to: 'src'
pin_all_from "app/javascript/controllers", under: "controllers"
