import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["banner"]
  static values = {
    websiteId: String
  }

  connect() {
    const consent = localStorage.getItem("cookie_consent")

    if (consent === "accepted") {
      this.loadUmami()
    } else if (!consent) {
      setTimeout(() => {
        this.bannerTarget.classList.remove("hidden")
      }, 500)
    }
  }

  accept() {
    localStorage.setItem("cookie_consent", "accepted")
    this.hideBanner()
    this.loadUmami()
  }

  decline() {
    localStorage.setItem("cookie_consent", "declined")
    this.hideBanner()
  }

  hideBanner() {
    this.bannerTarget.classList.add("hidden")
  }

  loadUmami() {
    if (document.getElementById("umami-script")) return

    const script = document.createElement("script")
    script.id = "umami-script"
    script.defer = true
    script.src = "https://cloud.umami.is/script.js"
    script.dataset.websiteId = this.websiteIdValue
    
    document.head.appendChild(script)
  }
}
