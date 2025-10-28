import { Controller } from "@hotwired/stimulus"
import Sortable from "@stimulus-components/sortable"
import { patch } from '@rails/request.js'

// Connects to data-controller="boards"
export default class extends Sortable {
  static values = {
    group: String,
    moveUrl: String
  }

  connect() {
    super.connect()
  }

  onEnd(event) {
    const storyId = event.item.dataset.storyId
    const boardId = event.to.dataset.boardId
    const newPosition = event.newIndex + 1 

    const url = this.moveUrlValue.replace(':id', storyId)
    const body = {
      story: {
        board_id: boardId,
        position: newPosition
      }
    }
    patch(url, { body: JSON.stringify(body) })
  }

  get defaultOptions() {
    return {
      group: this.groupValue,
      onEnd: this.onEnd.bind(this),
      forceFallback: true,
      delay: 100,
      delayOnTouchOnly: true
    }
  }
}
