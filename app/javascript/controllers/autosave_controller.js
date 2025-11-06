// app/javascript/controllers/autosave_controller.js
import { Controller } from '@hotwired/stimulus'
import { useDebounce } from 'stimulus-use'

export default class extends Controller {
  static targets = ["status"]
  static values = { url: String }
  static debounces = ['save']

  connect() {
    useDebounce(this, { wait: 1000 })
  }

  clearStatus() {
    if (this.hasStatusTarget && this.statusTarget.textContent === "Saved") {
      this.statusTarget.textContent = ""
    }
  }

  async save() {
    this.showStatus("Saving...")

    const formData = new FormData(this.element)
    
    try {
      const response = await fetch(this.urlValue, {
        method: 'PATCH',
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
          'Accept': 'application/json'
        },
        body: formData
      })

      if (response.ok) {
        this.showStatus("Saved", "success")
      } else {
        const errors = await response.json()
        console.error("Autosave failed:", errors)
        this.showStatus("Save failed", "error")
      }
    } catch (error) {
      console.error("Network error during autosave:", error)
      this.showStatus("Network error", "error")
    }
  }

  showStatus(message, state = "saving") {
    if (!this.hasStatusTarget) return

    this.statusTarget.textContent = message
    this.statusTarget.classList.remove("text-green-500", "text-red-500", "text-gray-500")

    if (state === "success") {
      this.statusTarget.classList.add("text-green-500")
    } else if (state === "error") {
      this.statusTarget.classList.add("text-red-500")
    } else {
      this.statusTarget.classList.add("text-gray-500")
    }
  }
}
