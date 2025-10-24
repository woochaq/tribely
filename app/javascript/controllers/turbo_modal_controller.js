import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="turbo-modal"
export default class extends Controller {
  static values = {
    baseUrl: String
  }

  connect() {
    this.frame = this.element.parentElement
    if (!this.frame || this.frame.tagName !== 'TURBO-FRAME') {
      console.error("Turbo modal controller must be a direct child of a <turbo-frame>.")
      return
    }

    // Bind the updateUrl function once and store a reference to it.
    // This is crucial for `removeEventListener` to work correctly.
    this.boundUpdateUrl = this.updateUrl.bind(this)

    // Add the event listener
    this.frame.addEventListener("turbo:frame-load", this.boundUpdateUrl)
  }

  disconnect() {
    // When the controller is disconnected (e.g., modal is closed),
    // clean up by removing the event listener to prevent memory leaks.
    if (this.frame) {
      this.frame.removeEventListener("turbo:frame-load", this.boundUpdateUrl)
    }
  }

  updateUrl() {
    const frameSrc = this.frame.getAttribute("src")
    if (frameSrc) {
      window.history.pushState({}, "", frameSrc)
    }
  }

  hideModal() {
    if (this.frame) {
      this.frame.removeAttribute("src")
      this.frame.innerHTML = "" // Clear the content
    }

    // When the modal is closed, revert the URL back to the base page.
    if (this.hasBaseUrlValue) {
      window.history.pushState({}, "", this.baseUrlValue)
    }
  }
}