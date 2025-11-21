import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  reset(event) {
    event.preventDefault()
    localStorage.removeItem("cookie_consent")
    window.location.reload()
  }
}
