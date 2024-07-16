import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="hiddenfield"
export default class extends Controller {
  static targets = ["role", "field"];

  connect() {
    this.toggleField();
  }

  toggleField() {
    const role = this.roleTarget.value;
    if (role === "visitor") {
      this.fieldTarget.classList.add("d-none");
    } else {
      this.fieldTarget.classList.remove("d-none");
    }
  }
}
