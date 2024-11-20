import { withPluginApi } from 'discourse/lib/plugin-api';

export default {
  name: 'color-user-names',

  initialize() {
    withPluginApi('0.8', api => {
      // No JavaScript manipulation for colors (handled server-side)
    });
  }
};