import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Debug Stimulus
application.debug = true
window.Stimulus = application

export { application }
