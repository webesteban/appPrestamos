import { Controller } from "@hotwired/stimulus"

// Conecta con data-controller="hierarchy"
export default class extends Controller {
  static targets = ["owner", "partner", "collector", "collection"]

  connect() {
    console.log("Hierarchy controller conectado ✅")
  }

  async loadPartners(event) {
    const ownerId = event.target.value
    console.log("loadPartners ejecutado con ownerId:", ownerId)

    if (!ownerId) return
    const url = `/hierarchy/${ownerId}/partners`
    const response = await fetch(url)
    const data = await response.json()

    this.partnerTarget.innerHTML = `<option value="">Seleccione un socio</option>`
    data.forEach(partner => {
      this.partnerTarget.innerHTML += `<option value="${partner.id}">${partner.name}</option>`
    })
  }

  async loadCollectors(event) {
    const partnerId = event.target.value
    console.log("loadCollectors ejecutado con partnerId:", partnerId)

    if (!partnerId) return
    const url = `/hierarchy/${partnerId}/collectors`
    const response = await fetch(url)
    const data = await response.json()

    this.collectorTarget.innerHTML = `<option value="">Seleccione un cobrador</option>`
    data.forEach(collector => {
      this.collectorTarget.innerHTML += `<option value="${collector.id}">${collector.name}</option>`
    })
  }

  async loadCollections(event) {
    const collectorId = event.target.value
    console.log("loadCollections ejecutado con collectorId:", collectorId)

    if (!collectorId) return
    const url = `/hierarchy/${collectorId}/collections`
    const response = await fetch(url)
    const data = await response.json()

    this.collectionTarget.innerHTML = `<option value="">Seleccione un Ruta</option>`
    data.forEach(collection => {
      this.collectionTarget.innerHTML += `<option value="${collection.id}">${collection.name}</option>`
    })
  }

  applyFilter() {
    console.log("applyFilter ejecutado")

    let level = null
    let id = null

    if (this.collectionTarget.value) {
      level = "collection"
      id = this.collectionTarget.value
    } else if (this.collectorTarget.value) {
      level = "collector"
      id = this.collectorTarget.value
    } else if (this.partnerTarget.value) {
      level = "partner"
      id = this.partnerTarget.value
    } else if (this.ownerTarget.value) {
      level = "owner"
      id = this.ownerTarget.value
    }

    if (level && id) {
      console.log(`Filtro aplicado: ${level} → ${id}`)
      const url = new URL(window.location.href)
      url.searchParams.set("level", level)
      url.searchParams.set("hierarchy_id", id)
      window.location.href = url.toString()
    } else {
      alert("Por favor selecciona un nivel válido de jerarquía")
    }
  }

  applyFilterSettlement() {

    let id = null

    if (this.collectionTarget.value) {
      id = this.collectionTarget.value
    } else {
        alert("Por favor selecciona una Ruta")
        return
    }
    window.location.href = `/settlements/${id}`
  }
}
