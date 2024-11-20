import { registerPlugin } from 'discourse/lib/plugins';
import ColorUserNameComponent from './components/color-user-name';
import ColorUserNameSettings from './settings';

registerPlugin({
  id: 'color-user-names',
  title: 'Color User Names',
  settings: ColorUserNameSettings.settings(),
  initialize() {
    this.addHelpers();
  }
});

function addHelpers() {
  const api = this.api;
  
  api.registerHelper('colorUserName', function(username, groups) {
    const colorMap = api.settings.color_map || {};
    
    let highestPriorityGroup = null;
    Object.keys(groups).sort((a, b) => groups[b] - groups[a]).forEach(group => {
      if (groups[group] > 0 && !highestPriorityGroup) {
        highestPriorityGroup = group;
      }
    });

    const color = colorMap[highestPriorityGroup] || '#000000'; // Default to black if no color found
    
    return `<span style="color: ${color};">${username}</span>`;
  });

  api.registerHelper('injectColorUserNameStyles', function() {
    const colorMap = api.settings.color_map || {};
    let styles = '';
    Object.entries(colorMap).forEach(([group, color]) => {
      styles += `:root { --${group}-color: ${color}; } `;
    });
    return `<style>${styles}</style>`;
  });
}