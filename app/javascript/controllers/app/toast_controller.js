import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { delay: { type: Number, default: 5000 } }

  connect() {
    if (this.delayValue > 0) {
      this.timeout = setTimeout(() => {
        this.close()
      }, this.delayValue)
    }
  }

  disconnect() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }

  close() {
    this.element.classList.add("opacity-0", "translate-x-full")

    this.element.addEventListener("transitionend", () => {
      this.element.remove()
    })
  }
}
