import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="hiddenfield"
export default class extends Controller {
  static targets = ["role", "field"];

  connect() {
    this.toggleField();
  }

  toggleField() {
    const role = this.roleTarget.value;
    role === "visitor" ? this.fieldTarget.classList.add("d-none") : this.fieldTarget.classList.remove("d-none");
  }
}
