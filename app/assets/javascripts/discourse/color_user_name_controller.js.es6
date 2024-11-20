import Ember from 'ember';
import { inject as service } from '@ember/service';

export default Ember.Controller.extend({
  colorUserNamesStore: service(),

  actions: {
    saveChanges() {
      const groupOrder = this.get('groupOrder');
      fetch('/color_user_names/group_order', {
        method: 'POST',
        body: JSON.stringify({ group_order: groupOrder }),
        headers: {
          'Content-Type': 'application/json'
        }
      })
      .then(() => {
        alert('Changes saved successfully!');
        this.set('isSaving', false);
      })
      .catch(error => {
        console.error('Error saving changes:', error);
        alert('Failed to save changes. Please try again.');
      });
    }
  },

  getGroupOrder() {
    return this.get('colorUserNamesStore.getGroupOrder') || {};
  },

  setGroupOrder(groupOrder) {
    this.set('groupOrder', groupOrder);
  }
});