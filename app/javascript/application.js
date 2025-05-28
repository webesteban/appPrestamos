// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "bootstrap" // si estás usando Bootstrap con importmap

import { createPopper } from "@popperjs/core"

// Opcional: si Bootstrap o algún plugin externo lo necesita globalmente
window.createPopper = createPopper

