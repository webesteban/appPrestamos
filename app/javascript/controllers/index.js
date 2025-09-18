import { application } from "./application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

// Carga automática de todos los controllers en este directorio
eagerLoadControllersFrom("controllers", application)
