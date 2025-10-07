import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="turbo-modal"
export default class extends Controller {
  static values = {
    baseUrl: String
  }

  hideModal() {
    this.element.parentElement.removeAttribute("src")
    this.element.remove()
    if (this.hasBaseUrlValue) {
      window.history.pushState({}, "", this.baseUrlValue)
    }
  }
}
