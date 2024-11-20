
import Controller from '@ember/controller';
import { action } from '@ember/object';
import { ajax } from 'discourse/lib/ajax';
import Sortable from 'sortablejs';

export default Controller.extend({
  init() {
    this._super(...arguments);
    this.set('sortable', null);
  },

  actions: {
    updateColor(groupId, event) {
      const color = event.target.value;
      ajax(`/admin/plugins/color-user-names/update_color/${groupId}`, {
        type: 'PUT',
        data: { color: color }
      }).then(() => {
        const group = this.model.groups.find(g => g.id === groupId);
        if (group) {
          group.color = color;
        }
      });
    }
  },

  didRender() {
    this._super(...arguments);

    if (!this.sortable) { 
      const el = document.querySelector('.color-user-names-settings');
      if (el) {
        this.sortable = new Sortable(el, {
          animation: 150,
          handle: '.group-color-setting',
          onUpdate: (event) => {
            const newOrder = Array.from(el.children).map(item => parseInt(item.dataset.groupId, 10));
            this.saveGroupOrder(newOrder);
          }
        });
      }
    }
  },

  willDestroyElement() {
    if (this.sortable) {
      this.sortable.destroy(); 
      this.set('sortable', null);
    }
  },

  saveGroupOrder(newOrder) {
    ajax('/admin/plugins/color-user-names/update_order', {
      type: 'PUT',
      data: { order: newOrder }
    }).then(() => {
      return ajax('/admin/plugins/color-user-names/groups').then((result) => {
        this.set('model.groups', result.groups)
      })
    });
  }
});