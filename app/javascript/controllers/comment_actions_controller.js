import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["actions"]
  static values = { userId: Number }

  connect() {
    const currentUserId = parseInt(document.body.dataset.currentUserId)

    if (currentUserId && currentUserId === this.userIdValue) {
      this.actionsTarget.classList.remove("hidden")
    }
  }
}
