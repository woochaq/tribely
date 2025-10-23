import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="wysiwyg"
export default class extends Controller {
  connect() {
    // const parent = this.element.parentNode;
    // if (parent) {
    //   const nextSibling = this.element.nextSibling;
    //   parent.removeChild(this.element);
    //   parent.insertBefore(this.element, nextSibling);
    // }
  }
}
