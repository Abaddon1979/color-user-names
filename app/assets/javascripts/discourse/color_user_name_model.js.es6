import Ember from 'ember';

export default Ember.Object.extend({
  getGroupOrder() {
    return ColorUserNames.get_group_order;
  },

  setGroupOrder(groupOrder) {
    ColorUserNames.create_group_order(Object.keys(groupOrder).join(','));
  }
});