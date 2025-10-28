import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="mobile-navigation"
export default class extends Controller {
  static targets = [ "sidebar" ]

  connect() {
    this.boundCloseOnResize = this.closeOnResize.bind(this)
    window.addEventListener("resize", this.boundCloseOnResize)
  }

  disconnect() {
    window.removeEventListener("resize", this.boundCloseOnResize)
  }

  toggle() {
    this.sidebarTarget.classList.toggle("hidden")
  }

  // Hide sidebar when resizing to a larger screen where it should be visible by default
  closeOnResize() {
    if (window.innerWidth >= 1024) { // Tailwind's 'lg' breakpoint
      if (!this.sidebarTarget.classList.contains("hidden")) {
        this.sidebarTarget.classList.add("hidden")
      }
    }
  }
}
