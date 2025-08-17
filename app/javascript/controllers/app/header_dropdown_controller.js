// app/javascript/controllers/app/header_dropdown_controller.js
import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="app--header-dropdown"
export default class extends Controller {
  static targets = [ "menu" ]

  connect() {
    // Use a bound function to ensure `this` is correct
    this.boundHide = this.hide.bind(this)
    document.addEventListener("click", this.boundHide)
    this.element.addEventListener("keydown", this.handleEscape.bind(this));
  }

  disconnect() {
    document.removeEventListener("click", this.boundHide)
    this.element.removeEventListener("keydown", this.handleEscape.bind(this));
  }

  toggle() {
    this.menuTarget.classList.toggle("hidden")
  }

  hide(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden")
    }
  }

  handleEscape(event) {
    if (event.key === "Escape") {
      this.menuTarget.classList.add("hidden");
    }
  }
}
