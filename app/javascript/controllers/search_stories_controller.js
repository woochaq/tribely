import { Controller } from "@hotwired/stimulus"
import { useDebounce } from "stimulus-use"

export default class extends Controller {
  static targets = ["form", "input", "spinner"]
  static debounces = ["performSearch"]

  connect() {
    useDebounce(this)
    this.activeIndex = -1
    this.formTarget.addEventListener("turbo:submit-end", this.hideSpinner)
  }

  disconnect() {
    this.formTarget.removeEventListener("turbo:submit-end", this.hideSpinner)
  }

  // Triggered on input. Submits the form after a delay.
  performSearch() {
    if (this.inputTarget.value.trim() === "") {
      this.clearResults()
      return
    }
    this.showSpinner()
    this.formTarget.requestSubmit()
  }

  // Hides results and clears input when clicking outside the component.
  hideResultsOnClickOutside = (event) => {
    if (!this.element.contains(event.target)) {
      this.clearResults()
    }
  }

  // Hides results and clears input on Escape key.
  hideResultsOnEscape = (event) => {
    if (event.key === "Escape") {
      this.clearResults()
    }
  }

  // Main function for keyboard navigation.
  navigate(event) {
    if (!this.hasResultsTarget) return

    const items = this.resultsTarget.querySelectorAll("a")
    if (items.length === 0) return

    switch (event.key) {
      case "ArrowDown":
        event.preventDefault()
        this.activeIndex = (this.activeIndex + 1) % items.length
        this.updateActiveItem(items)
        break
      case "ArrowUp":
        event.preventDefault()
        this.activeIndex = (this.activeIndex - 1 + items.length) % items.length
        this.updateActiveItem(items)
        break
      case "Enter":
        event.preventDefault()
        if (this.activeIndex >= 0) {
          items[this.activeIndex].click()
        }
        break
    }
  }

  // Updates visual state of the active item.
  updateActiveItem(items) {
    items.forEach((item, index) => {
      if (index === this.activeIndex) {
        item.classList.add("bg-surface2") // Same as hover state
      } else {
        item.classList.remove("bg-surface2")
      }
    })
  }

  // Clears the search input and the results frame.
  clearResults() {
    // Use a small timeout to allow Turbo to process the link click
    // before we remove the element from the DOM.
    setTimeout(() => {
      if (this.hasInputTarget) {
        this.inputTarget.value = ""
      }
      const turboFrame = this.element.querySelector("turbo-frame#search_results")
      if (turboFrame) {
        turboFrame.innerHTML = ""
      }
      this.activeIndex = -1
      this.hideSpinner()
    }, 50)
  }

  showSpinner() {
    if (this.hasSpinnerTarget) {
      this.spinnerTarget.classList.remove("hidden")
    }
  }

  hideSpinner = () => {
    if (this.hasSpinnerTarget) {
      this.spinnerTarget.classList.add("hidden")
    }
  }

  // Attach/detach global event listeners.
  resultsTargetConnected() {
    document.addEventListener("click", this.hideResultsOnClickOutside)
    document.addEventListener("keydown", this.hideResultsOnEscape)
  }

  resultsTargetDisconnected() {
    document.removeEventListener("click", this.hideResultsOnClickOutside)
    document.removeEventListener("keydown", this.hideResultsOnEscape)
  }
}
