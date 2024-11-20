export default function(container) {
    const router = container.lookup('router:main');
    
    router.on('route:admin.settings.color_user_names', () => {
      container.lookup('controller:admin').render();
    });
  };