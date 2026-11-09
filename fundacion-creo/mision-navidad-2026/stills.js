// Capturas de control en tiempos clave: node stills.js t1 t2 ...
const { chromium } = require('playwright'); const path = require('path');
(async () => {
  const b = await chromium.launch();
  const p = await b.newPage({ viewport: { width: 1080, height: 1920 } });
  p.on('pageerror', e => console.log('ERR', e.message));
  await p.goto('file://' + path.resolve(__dirname, 'reel.html'));
  await p.evaluate(() => window.ready);
  for (const t of process.argv.slice(2)) {
    await p.evaluate(t => window.setTime(t), +t);
    await p.screenshot({ path: `${process.env.OUT}/t${t}.jpg`, type: 'jpeg', quality: 80 });
  }
  await b.close();
})();
