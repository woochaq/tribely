// app/javascript/controllers/avatar_preview_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview"]

  updatePreview() {
    const file = this.inputTarget.files[0]
    if (file) {
      this.previewTarget.src = URL.createObjectURL(file)
    }
  }
}
